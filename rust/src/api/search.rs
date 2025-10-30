use tantivy::collector::TopDocs;
use tantivy::query::QueryParser;
use tantivy::schema::{
    Field, IndexRecordOption, JsonObjectOptions, Schema, TextFieldIndexing, TextOptions, Value,
};
use tantivy::tokenizer::NgramTokenizer;
use tantivy::{doc, Index, TantivyDocument};

use lindera::dictionary::load_dictionary;
use lindera::mode::Mode;
use lindera::segmenter::Segmenter;
use lindera_tantivy::tokenizer::LinderaTokenizer;

use serde_json::Value as JsonValue;
use std::sync::Mutex;
use std::path::Path;

// 사전 타입 enum
#[derive(Clone, Debug)]
pub enum DictionaryType {
    Korean,                 // ko-dic
    JapaneseIpadic,        // ipadic
    // JapaneseIpadicNeologd, // ipadic-neologd
    JapaneseUnidic,        // unidic
    Chinese,               // cc-cedict
}

impl DictionaryType {
    fn to_embedded_path(&self) -> &'static str {
        match self {
            DictionaryType::Korean => "embedded://ko-dic",
            DictionaryType::JapaneseIpadic => "embedded://ipadic",
            // DictionaryType::JapaneseIpadicNeologd => "embedded://ipadic-neologd",
            DictionaryType::JapaneseUnidic => "embedded://unidic",
            DictionaryType::Chinese => "embedded://cc-cedict",
        }
    }

    fn to_tokenizer_name(&self) -> &'static str {
        match self {
            DictionaryType::Korean => "lang_ko",
            DictionaryType::JapaneseIpadic => "lang_ja_ipadic",
            // DictionaryType::JapaneseIpadicNeologd => "lang_ja_ipadic_neologd",
            DictionaryType::JapaneseUnidic => "lang_ja_unidic",
            DictionaryType::Chinese => "lang_zh",
        }
    }
}

// 검색 결과를 담는 구조체
#[derive(Clone, Debug)]
pub struct SearchResult {
    pub id: String,
    pub title: String,
    pub body: String,
    pub score: f32,
    pub metadata: String, // JSON string
}

// 인덱스를 관리하는 전역 상태
static SEARCH_INDEX: Mutex<Option<SearchIndex>> = Mutex::new(None);

struct SearchIndex {
    index: Index,
    schema: Schema,
    id_field: Field,
    title_field: Field,
    body_field: Field,
    metadata_field: Field,
    // N-gram 필드 추가 (부분 검색용)
    title_ngram_field: Field,
    body_ngram_field: Field,
}

/// 검색 인덱스를 초기화합니다
#[flutter_rust_bridge::frb(sync)]
pub fn initialize_search_index(dictionary_type: DictionaryType) -> Result<String, String> {
    // create schema builder
    let mut schema_builder = Schema::builder();

    // 선택한 사전에 맞는 토크나이저 이름 가져오기
    let tokenizer_name = dictionary_type.to_tokenizer_name();

    // add id field (UUID 문자열)
    let id = schema_builder.add_text_field(
        "id",
        TextOptions::default()
            .set_indexing_options(
                TextFieldIndexing::default()
                    .set_tokenizer("raw")
                    .set_index_option(IndexRecordOption::Basic),
            )
            .set_stored(),
    );

    // add title field (형태소 분석)
    let title = schema_builder.add_text_field(
        "title",
        TextOptions::default()
            .set_indexing_options(
                TextFieldIndexing::default()
                    .set_tokenizer(tokenizer_name)
                    .set_index_option(IndexRecordOption::WithFreqsAndPositions),
            )
            .set_stored(),
    );

    // add body field (형태소 분석)
    let body = schema_builder.add_text_field(
        "body",
        TextOptions::default()
            .set_indexing_options(
                TextFieldIndexing::default()
                    .set_tokenizer(tokenizer_name)
                    .set_index_option(IndexRecordOption::WithFreqsAndPositions),
            )
            .set_stored(),
    );

    // add title_ngram field (부분 검색용)
    let title_ngram = schema_builder.add_text_field(
        "title_ngram",
        TextOptions::default()
            .set_indexing_options(
                TextFieldIndexing::default()
                    .set_tokenizer("ngram_tokenizer")
                    .set_index_option(IndexRecordOption::WithFreqsAndPositions),
            )
            .set_stored(),
    );

    // add body_ngram field (부분 검색용)
    let body_ngram = schema_builder.add_text_field(
        "body_ngram",
        TextOptions::default()
            .set_indexing_options(
                TextFieldIndexing::default()
                    .set_tokenizer("ngram_tokenizer")
                    .set_index_option(IndexRecordOption::WithFreqsAndPositions),
            )
            .set_stored(),
    );

    // add metadata field (JSON Object)
    let metadata = schema_builder.add_json_field(
        "metadata",
        JsonObjectOptions::default()
            .set_indexing_options(
                TextFieldIndexing::default()
                    .set_tokenizer("raw")
                    .set_index_option(IndexRecordOption::Basic),
            )
            .set_stored(),
    );

    // build schema
    let schema = schema_builder.build();

    // create index on memory
    let index = Index::create_in_ram(schema.clone());

    // Register N-gram tokenizer (2-gram ~ 3-gram for Korean, prefix_only=false)
    index
        .tokenizers()
        .register("ngram_tokenizer", NgramTokenizer::new(2, 3, false).unwrap());

    // Tokenizer with selected dictionary
    let mode = Mode::Normal;
    let dictionary = load_dictionary(dictionary_type.to_embedded_path()).map_err(|e| e.to_string())?;
    let user_dictionary = None;
    let segmenter = Segmenter::new(mode, dictionary, user_dictionary);
    let tokenizer = LinderaTokenizer::from_segmenter(segmenter);

    // register Lindera tokenizer
    index.tokenizers().register(tokenizer_name, tokenizer);

    // 전역 상태에 저장
    let mut search_index = SEARCH_INDEX.lock().unwrap();
    *search_index = Some(SearchIndex {
        index,
        schema,
        id_field: id,
        title_field: title,
        body_field: body,
        metadata_field: metadata,
        title_ngram_field: title_ngram,
        body_ngram_field: body_ngram,
    });

    Ok("검색 인덱스가 초기화되었습니다.".to_string())
}

/// 디스크에 인덱스를 생성하거나 로드합니다
#[flutter_rust_bridge::frb(sync)]
pub fn initialize_search_index_with_path(dictionary_type: DictionaryType, index_path: String) -> Result<String, String> {
    // create schema builder
    let mut schema_builder = Schema::builder();

    // 선택한 사전에 맞는 토크나이저 이름 가져오기
    let tokenizer_name = dictionary_type.to_tokenizer_name();

    // add id field (UUID 문자열)
    let id = schema_builder.add_text_field(
        "id",
        TextOptions::default()
            .set_indexing_options(
                TextFieldIndexing::default()
                    .set_tokenizer("raw")
                    .set_index_option(IndexRecordOption::Basic),
            )
            .set_stored(),
    );

    // add title field (형태소 분석)
    let title = schema_builder.add_text_field(
        "title",
        TextOptions::default()
            .set_indexing_options(
                TextFieldIndexing::default()
                    .set_tokenizer(tokenizer_name)
                    .set_index_option(IndexRecordOption::WithFreqsAndPositions),
            )
            .set_stored(),
    );

    // add body field (형태소 분석)
    let body = schema_builder.add_text_field(
        "body",
        TextOptions::default()
            .set_indexing_options(
                TextFieldIndexing::default()
                    .set_tokenizer(tokenizer_name)
                    .set_index_option(IndexRecordOption::WithFreqsAndPositions),
            )
            .set_stored(),
    );

    // add title_ngram field (부분 검색용)
    let title_ngram = schema_builder.add_text_field(
        "title_ngram",
        TextOptions::default()
            .set_indexing_options(
                TextFieldIndexing::default()
                    .set_tokenizer("ngram_tokenizer")
                    .set_index_option(IndexRecordOption::WithFreqsAndPositions),
            )
            .set_stored(),
    );

    // add body_ngram field (부분 검색용)
    let body_ngram = schema_builder.add_text_field(
        "body_ngram",
        TextOptions::default()
            .set_indexing_options(
                TextFieldIndexing::default()
                    .set_tokenizer("ngram_tokenizer")
                    .set_index_option(IndexRecordOption::WithFreqsAndPositions),
            )
            .set_stored(),
    );

    // add metadata field (JSON Object)
    let metadata = schema_builder.add_json_field(
        "metadata",
        JsonObjectOptions::default()
            .set_indexing_options(
                TextFieldIndexing::default()
                    .set_tokenizer("raw")
                    .set_index_option(IndexRecordOption::Basic),
            )
            .set_stored(),
    );

    // build schema
    let schema = schema_builder.build();

    // 디스크 경로가 존재하는지 확인
    let path = Path::new(&index_path);
    let index = if path.exists() {
        // 기존 인덱스 로드
        Index::open_in_dir(path).map_err(|e| format!("인덱스 로드 실패: {}", e))?
    } else {
        // 새 인덱스 생성
        std::fs::create_dir_all(path).map_err(|e| format!("디렉토리 생성 실패: {}", e))?;
        Index::create_in_dir(path, schema.clone()).map_err(|e| format!("인덱스 생성 실패: {}", e))?
    };

    // Register N-gram tokenizer (2-gram ~ 3-gram for Korean, prefix_only=false)
    index
        .tokenizers()
        .register("ngram_tokenizer", NgramTokenizer::new(2, 3, false).unwrap());

    // Tokenizer with selected dictionary
    let mode = Mode::Normal;
    let dictionary = load_dictionary(dictionary_type.to_embedded_path()).map_err(|e| e.to_string())?;
    let user_dictionary = None;
    let segmenter = Segmenter::new(mode, dictionary, user_dictionary);
    let tokenizer = LinderaTokenizer::from_segmenter(segmenter);

    // register Lindera tokenizer
    index.tokenizers().register(tokenizer_name, tokenizer);

    // 전역 상태에 저장
    let mut search_index = SEARCH_INDEX.lock().unwrap();
    *search_index = Some(SearchIndex {
        index,
        schema,
        id_field: id,
        title_field: title,
        body_field: body,
        metadata_field: metadata,
        title_ngram_field: title_ngram,
        body_ngram_field: body_ngram,
    });

    Ok(format!("검색 인덱스가 초기화되었습니다. (경로: {})", index_path))
}

/// 샘플 문서를 인덱싱합니다
#[flutter_rust_bridge::frb(sync)]
pub fn index_sample_documents() -> Result<String, String> {
    let mut search_index = SEARCH_INDEX.lock().unwrap();
    let search_index = search_index.as_mut().ok_or(
        "검색 인덱스가 초기화되지 않았습니다. initialize_search_index()를 먼저 호출하세요.",
    )?;

    let id = search_index.id_field;
    let title = search_index.title_field;
    let body = search_index.body_field;
    let metadata = search_index.metadata_field;
    let title_ngram = search_index.title_ngram_field;
    let body_ngram = search_index.body_ngram_field;

    // create index writer
    let mut index_writer = search_index
        .index
        .writer(50_000_000)
        .map_err(|e| e.to_string())?;

    // add documents with metadata
    index_writer.add_document(doc!(
        id => generate_uuid(),
        title => "나리타 국제공항",
        body => "나리타 국제공항(일본어: 成田国際空港, 영어: Narita International Airport, IATA: NRT, ICAO: RJAA)은 일본 지바현 나리타시에 위치한 국제공항으로, 도쿄도 도심에서 동북쪽으로 약 62km 떨어져 있다.",
        metadata => serde_json::json!({"country": "일본", "iata": "NRT", "icao": "RJAA", "city": "나리타"}),
        title_ngram => "나리타 국제",
        body_ngram => "나리타 국제공항"
    )).map_err(|e| e.to_string())?;

    index_writer.add_document(doc!(
        id => generate_uuid(),
        title => "도쿄 국제공항",
        body => "도쿄국제공항(일본어: 東京国際空港、とうきょうこくさいくうこう, 영어: Tokyo International Airport)은 일본 도쿄도 오타구에 있는 공항이다. 보통 이 일대의 옛 지명을 본뜬 하네다 공항(일본어: 羽田空港, 영어: Haneda Airport)이라고 불린다.",
        metadata => serde_json::json!({"country": "일본", "iata": "HND", "icao": "RJTT", "city": "도쿄"}),
        title_ngram => "도쿄 국제",
        body_ngram => "도쿄국제공항"
    )).map_err(|e| e.to_string())?;

    index_writer.add_document(doc!(
        id => generate_uuid(),
        title => "간사이 국제공항",
        body => "간사이 국제공항(일본어: 関西国際空港, IATA: KIX, ICAO: RJBB)은 일본 오사카부 오사카 만에 조성된 인공섬에 위치한 일본의 공항으로, 대한민국의 인천국제공항보다 6년 반 앞선 1994년 9월 4일에 개항했다.",
        metadata => serde_json::json!({"country": "일본", "iata": "KIX", "icao": "RJBB", "city": "오사카"}),
        title_ngram => "간사이 국제",
        body_ngram => "간사이 국제공항"
    )).map_err(|e| e.to_string())?;

    index_writer.add_document(doc!(
        id => generate_uuid(),
        title => "인천국제공항",
        body => "인천국제공항(仁川國際空港, Incheon International Airport, IATA: ICN, ICAO: RKSI)은 대한민국 인천광역시 중구 운서동에 있는 국제공항이다. 2001년 3월 29일 개항하였다.",
        metadata => serde_json::json!({"country": "한국", "iata": "ICN", "icao": "RKSI", "city": "인천"}),
        title_ngram => "인천국제",
        body_ngram => "인천국제공항"
    )).map_err(|e| e.to_string())?;

    index_writer.add_document(doc!(
        id => generate_uuid(),
        title => "김포국제공항",
        body => "김포국제공항(金浦國際空港, Gimpo International Airport, IATA: GMP, ICAO: RKSS)은 대한민국 서울특별시 강서구 공항동에 있는 국제공항이다. 서울 도심에서 서쪽으로 약 15km 떨어져 있다.",
        metadata => serde_json::json!({"country": "한국", "iata": "GMP", "icao": "RKSS", "city": "서울"}),
        title_ngram => "김포국제",
        body_ngram => "김포국제공항"
    )).map_err(|e| e.to_string())?;

    index_writer.add_document(doc!(
        id => generate_uuid(),
        title => "제주국제공항",
        body => "제주국제공항(濟州國際空港, Jeju International Airport, IATA: CJU, ICAO: RKPC)은 대한민국 제주특별자치도 제주시 용담동에 있는 국제공항이다. 한국에서 가장 많은 승객이 이용하는 공항이다.",
        metadata => serde_json::json!({"country": "한국", "iata": "CJU", "icao": "RKPC", "city": "제주"}),
        title_ngram => "제주국제",
        body_ngram => "제주국제공항"
    )).map_err(|e| e.to_string())?;

    index_writer.add_document(doc!(
        id => generate_uuid(),
        title => "싱가포르 창이공항",
        body => "싱가포르 창이공항(Singapore Changi Airport, IATA: SIN, ICAO: WSSS)은 싱가포르에 있는 국제공항이다. 세계적으로 유명한 허브공항이며, 최고의 서비스로 ��러 차례 수상한 바 있다.",
        metadata => serde_json::json!({"country": "싱가포르", "iata": "SIN", "icao": "WSSS", "city": "싱가포르"}),
        title_ngram => "싱가포르 창이",
        body_ngram => "싱가포르 창이공항"
    )).map_err(|e| e.to_string())?;

    index_writer.add_document(doc!(
        id => generate_uuid(),
        title => "홍콩국제공항",
        body => "홍콩국제공항(香港國際機場, Hong Kong International Airport, IATA: HKG, ICAO: VHHH)은 중화인민공화국 홍콩특별행정구에 있는 국제공항이다. 란타우섬 북쪽 해상의 인공섬에 위치한다.",
        metadata => serde_json::json!({"country": "홍콩", "iata": "HKG", "icao": "VHHH", "city": "홍콩"}),
        title_ngram => "홍콩국제",
        body_ngram => "홍콩국제공항"
    )).map_err(|e| e.to_string())?;

    // 일본어 예제 추가
    index_writer.add_document(doc!(
        id => generate_uuid(),
        title => "東京国際空港",
        body => "東京国際空港（とうきょうこくさいくうこう）は、東京都大田区にある日本最大の空港である。通称は羽田空港。国内線・国際線ともに多くの路線を持つ重要な拠点空港である。",
        metadata => serde_json::json!({"country": "日本", "iata": "HND", "icao": "RJTT", "city": "東京", "language": "ja"}),
        title_ngram => "東京国際空港",
        body_ngram => "東京国際空港"
    )).map_err(|e| e.to_string())?;

    index_writer.add_document(doc!(
        id => generate_uuid(),
        title => "関西国際空港",
        body => "関西国際空港（かんさいこくさいくうこう）は、大阪府泉佐野市にある国際空港である。愛称は「関空」。大阪湾の人工島に建設され、24時間運用可能な空港として知られている。",
        metadata => serde_json::json!({"country": "日本", "iata": "KIX", "icao": "RJBB", "city": "大阪", "language": "ja"}),
        title_ngram => "関西国際空港",
        body_ngram => "関西国際空港"
    )).map_err(|e| e.to_string())?;

    index_writer.add_document(doc!(
        id => generate_uuid(),
        title => "中部国際空港",
        body => "中部国際空港（ちゅうぶこくさいくうこう）は、愛知県常滑市にある国際空港である。愛称はセントレア。名古屋の玄関口として、中部地方の経済発展に貢献している。",
        metadata => serde_json::json!({"country": "日本", "iata": "NGO", "icao": "RJGG", "city": "名古屋", "language": "ja"}),
        title_ngram => "中部国際空港",
        body_ngram => "中部国際空港"
    )).map_err(|e| e.to_string())?;

    // 중국어 예제 추가
    index_writer.add_document(doc!(
        id => generate_uuid(),
        title => "北京首都国际机场",
        body => "北京首都国际机场是中国最繁忙的机场之一，位于北京市顺义区。作为中国国际航空的主要枢纽，连接世界各地的重要航线。机场设施完善，服务优质。",
        metadata => serde_json::json!({"country": "中国", "iata": "PEK", "icao": "ZBAA", "city": "北京", "language": "zh"}),
        title_ngram => "北京首都国际机场",
        body_ngram => "北京首都国际机场"
    )).map_err(|e| e.to_string())?;

    index_writer.add_document(doc!(
        id => generate_uuid(),
        title => "上海浦东国际机场",
        body => "上海浦东国际机场是中国三大门户复合枢纽之一，位于上海市浦东新区。是上海两座国际机场之一，主要服务国际航班。机场现代化程度高，吞吐量巨大。",
        metadata => serde_json::json!({"country": "中国", "iata": "PVG", "icao": "ZSPD", "city": "上海", "language": "zh"}),
        title_ngram => "上海浦东国际机场",
        body_ngram => "上海浦东国际机场"
    )).map_err(|e| e.to_string())?;

    index_writer.add_document(doc!(
        id => generate_uuid(),
        title => "广州白云国际机场",
        body => "广州白云国际机场位于广州市白云区，是中国三大航空枢纽之一。作为华南地区最大的交通枢纽，连接国内外众多城市。机场配套设施齐全，交通便利。",
        metadata => serde_json::json!({"country": "中国", "iata": "CAN", "icao": "ZGGG", "city": "广州", "language": "zh"}),
        title_ngram => "广州白云国际机场",
        body_ngram => "广州白云国际机场"
    )).map_err(|e| e.to_string())?;

    // 한국어 추가 예제 (부분 검색 테스트용)
    index_writer.add_document(doc!(
        id => generate_uuid(),
        title => "우리 할아버지",
        body => "우리 할아버지는 항상 아버지에게 좋은 가르침을 주셨다. 할머니와 함께 시골에서 농사를 지으며 평화롭게 살고 계신다.",
        metadata => serde_json::json!({"category": "가족", "language": "ko"}),
        title_ngram => "우리 할아버지",
        body_ngram => "우리 할아버지"
    )).map_err(|e| e.to_string())?;

    // commit
    index_writer.commit().map_err(|e| e.to_string())?;

    Ok("총 15개의 문서가 인덱싱되었습니다. (한국어 9개, 일본어 3개, 중국어 3개)".to_string())
}

/// 문서를 검색합니다 (형태소 분석 + N-gram 부분 검색)
#[flutter_rust_bridge::frb(sync)]
pub fn search_documents(query_str: String, limit: usize) -> Result<Vec<SearchResult>, String> {
    let search_index = SEARCH_INDEX.lock().unwrap();
    let search_index = search_index.as_ref().ok_or(
        "검색 인덱스가 초기화되지 않았습니다. initialize_search_index()를 먼저 호출하세요.",
    )?;

    let id = search_index.id_field;
    let title = search_index.title_field;
    let body = search_index.body_field;
    let metadata = search_index.metadata_field;
    let title_ngram = search_index.title_ngram_field;
    let body_ngram = search_index.body_ngram_field;

    // create reader
    let reader = search_index.index.reader().map_err(|e| e.to_string())?;

    // create query parser - 형태소 분석 필드와 N-gram 필드 모두 포함
    let query_parser = QueryParser::for_index(
        &search_index.index,
        vec![title, body, title_ngram, body_ngram],
    );

    // parse query
    let query = query_parser
        .parse_query(&query_str)
        .map_err(|e| e.to_string())?;

    // create searcher
    let searcher = reader.searcher();

    // search
    let top_docs = searcher
        .search(&query, &TopDocs::with_limit(limit))
        .map_err(|e| e.to_string())?;

    // 결과 변환
    let mut results = Vec::new();
    for (score, doc_address) in top_docs {
        let retrieved_doc: TantivyDocument =
            searcher.doc(doc_address).map_err(|e| e.to_string())?;

        let id_value = retrieved_doc
            .get_first(id)
            .and_then(|v| v.as_str())
            .unwrap_or("")
            .to_string();

        let title_value = retrieved_doc
            .get_first(title)
            .and_then(|v| v.as_str())
            .unwrap_or("")
            .to_string();

        let body_value = retrieved_doc
            .get_first(body)
            .and_then(|v| v.as_str())
            .unwrap_or("")
            .to_string();

        let metadata_value = retrieved_doc
            .get_first(metadata)
            .map(|v| {
                // Convert to JSON string
                if let Some(s) = v.as_str() {
                    s.to_string()
                } else if let Some(obj_iter) = v.as_object() {
                    // Convert iterator to HashMap and serialize
                    let map: std::collections::HashMap<String, serde_json::Value> = obj_iter
                        .map(|(k, v)| {
                            // Convert each value to serde_json::Value
                            let json_val = if let Some(s) = v.as_str() {
                                serde_json::Value::String(s.to_string())
                            } else if let Some(num) = v.as_u64() {
                                serde_json::Value::Number(num.into())
                            } else if let Some(num) = v.as_i64() {
                                serde_json::Value::Number(num.into())
                            } else if let Some(num) = v.as_f64() {
                                serde_json::json!(num)
                            } else if let Some(b) = v.as_bool() {
                                serde_json::Value::Bool(b)
                            } else if let Some(arr) = v.as_array() {
                                // 배열 처리 추가!
                                // CompactDocArrayIter는 이미 iterator이므로 collect()로 바로 변환
                                let array_values: Vec<serde_json::Value> = arr
                                    .map(|item| {
                                        if let Some(s) = item.as_str() {
                                            serde_json::Value::String(s.to_string())
                                        } else if let Some(num) = item.as_u64() {
                                            serde_json::Value::Number(num.into())
                                        } else if let Some(num) = item.as_i64() {
                                            serde_json::Value::Number(num.into())
                                        } else if let Some(num) = item.as_f64() {
                                            serde_json::json!(num)
                                        } else if let Some(b) = item.as_bool() {
                                            serde_json::Value::Bool(b)
                                        } else {
                                            serde_json::Value::Null
                                        }
                                    })
                                    .collect();
                                serde_json::Value::Array(array_values)
                            } else {
                                serde_json::Value::Null
                            };
                            (k.to_string(), json_val)
                        })
                        .collect();
                    serde_json::to_string(&map).unwrap_or_else(|_| "{}".to_string())
                } else {
                    "{}".to_string()
                }
            })
            .unwrap_or_else(|| "{}".to_string());

        results.push(SearchResult {
            id: id_value,
            title: title_value,
            body: body_value,
            score,
            metadata: metadata_value,
        });
    }

    Ok(results)
}

/// 커스텀 문서를 추가합니다 (UUID 자동 생성)
#[flutter_rust_bridge::frb(sync)]
pub fn add_document(title: String, body: String, metadata_json: String) -> Result<String, String> {
    let mut search_index = SEARCH_INDEX.lock().unwrap();
    let search_index = search_index.as_mut().ok_or(
        "검색 인덱스가 초기화되지 않았습니다. initialize_search_index()를 먼저 호출하세요.",
    )?;

    let id_field = search_index.id_field;
    let title_field = search_index.title_field;
    let body_field = search_index.body_field;
    let metadata_field = search_index.metadata_field;
    let title_ngram_field = search_index.title_ngram_field;
    let body_ngram_field = search_index.body_ngram_field;

    // Parse JSON metadata
    let metadata: JsonValue =
        serde_json::from_str(&metadata_json).unwrap_or_else(|_| serde_json::json!({}));

    // Generate UUID
    let uuid = generate_uuid();

    // create index writer
    let mut index_writer = search_index
        .index
        .writer(50_000_000)
        .map_err(|e| e.to_string())?;

    // add document
    index_writer
        .add_document(doc!(
            id_field => uuid.clone(),
            title_field => title,
            body_field => body,
            metadata_field => metadata,
            title_ngram_field => title,
            body_ngram_field => body
        ))
        .map_err(|e| e.to_string())?;

    // commit
    index_writer.commit().map_err(|e| e.to_string())?;

    Ok(format!("문서 ID '{}'가 추가되었습니다.", uuid))
}

/// 여러 문서를 한 번에 추가합니다 (UUID 자동 생성)
#[flutter_rust_bridge::frb(sync)]
pub fn add_documents(documents: Vec<DocumentInput>) -> Result<String, String> {
    let mut search_index = SEARCH_INDEX.lock().unwrap();
    let search_index = search_index.as_mut().ok_or(
        "검색 인덱스가 초기화되지 않았습니다. initialize_search_index()를 먼저 호출하세요.",
    )?;

    let id_field = search_index.id_field;
    let title_field = search_index.title_field;
    let body_field = search_index.body_field;
    let metadata_field = search_index.metadata_field;
    let title_ngram_field = search_index.title_ngram_field;
    let body_ngram_field = search_index.body_ngram_field;

    // create index writer
    let mut index_writer = search_index
        .index
        .writer(50_000_000)
        .map_err(|e| e.to_string())?;

    // add documents
    for doc_input in &documents {
        let metadata: JsonValue =
            serde_json::from_str(&doc_input.metadata).unwrap_or_else(|_| serde_json::json!({}));

        let uuid = if doc_input.id.is_empty() {
            generate_uuid()
        } else {
            doc_input.id.clone()
        };

        index_writer
            .add_document(doc!(
                id_field => uuid,
                title_field => doc_input.title.clone(),
                body_field => doc_input.body.clone(),
                metadata_field => metadata,
                title_ngram_field => doc_input.title.clone(),
                body_ngram_field => doc_input.body.clone()
            ))
            .map_err(|e| e.to_string())?;
    }

    // commit
    index_writer.commit().map_err(|e| e.to_string())?;

    Ok(format!("총 {}개의 문서가 추가되었습니다.", documents.len()))
}

/// 문서를 업데이트합니다 (ID로 찾아서 삭제 후 재추가)
#[flutter_rust_bridge::frb(sync)]
pub fn update_document(
    id: String,
    title: String,
    body: String,
    metadata_json: String,
) -> Result<String, String> {
    let mut search_index = SEARCH_INDEX.lock().unwrap();
    let search_index = search_index.as_mut().ok_or(
        "검색 인덱스가 초기화되지 않았습니다. initialize_search_index()를 먼저 호출하세요.",
    )?;

    let id_field = search_index.id_field;
    let title_field = search_index.title_field;
    let body_field = search_index.body_field;
    let metadata_field = search_index.metadata_field;
    let title_ngram_field = search_index.title_ngram_field;
    let body_ngram_field = search_index.body_ngram_field;

    // Parse JSON metadata
    let metadata: JsonValue =
        serde_json::from_str(&metadata_json).unwrap_or_else(|_| serde_json::json!({}));

    // create index writer
    let mut index_writer = search_index
        .index
        .writer(50_000_000)
        .map_err(|e| e.to_string())?;

    // ID로 기존 문서 삭제
    let id_term = tantivy::Term::from_field_text(id_field, &id);
    index_writer.delete_term(id_term);

    // 새 문서 추가
    index_writer
        .add_document(doc!(
            id_field => id.clone(),
            title_field => title,
            body_field => body,
            metadata_field => metadata,
            title_ngram_field => title,
            body_ngram_field => body
        ))
        .map_err(|e| e.to_string())?;

    // commit
    index_writer.commit().map_err(|e| e.to_string())?;

    Ok(format!("문서 ID '{}'가 업데이트되었습니다.", id))
}

/// ID로 문서를 삭제합니다
#[flutter_rust_bridge::frb(sync)]
pub fn delete_document(id: String) -> Result<String, String> {
    let mut search_index = SEARCH_INDEX.lock().unwrap();
    let search_index = search_index.as_mut().ok_or(
        "검색 인덱스가 초기화되지 않았습니다. initialize_search_index()를 먼저 호출하세요.",
    )?;

    let id_field = search_index.id_field;

    // create index writer with explicit type
    let mut index_writer: tantivy::IndexWriter = search_index
        .index
        .writer(50_000_000)
        .map_err(|e| e.to_string())?;

    // ID로 문서 삭제
    let id_term = tantivy::Term::from_field_text(id_field, &id);
    index_writer.delete_term(id_term);

    // commit
    index_writer.commit().map_err(|e| e.to_string())?;

    Ok(format!("문서 ID '{}'가 삭제되었습니다.", id))
}

/// 여러 문서를 한 번에 삭제합니다
#[flutter_rust_bridge::frb(sync)]
pub fn delete_documents(ids: Vec<String>) -> Result<String, String> {
    let mut search_index = SEARCH_INDEX.lock().unwrap();
    let search_index = search_index.as_mut().ok_or(
        "검색 인덱스가 초기화되지 않았습니다. initialize_search_index()를 먼저 호출하세요.",
    )?;

    let id_field = search_index.id_field;

    // create index writer with explicit type
    let mut index_writer: tantivy::IndexWriter = search_index
        .index
        .writer(50_000_000)
        .map_err(|e| e.to_string())?;

    // 모든 ID의 문서 삭제
    for id in &ids {
        let id_term = tantivy::Term::from_field_text(id_field, id);
        index_writer.delete_term(id_term);
    }

    // commit
    index_writer.commit().map_err(|e| e.to_string())?;

    Ok(format!("총 {}개의 문서가 삭제되었습니다.", ids.len()))
}

/// 모든 문서를 삭제합니다
#[flutter_rust_bridge::frb(sync)]
pub fn clear_all_documents() -> Result<String, String> {
    let mut search_index_guard = SEARCH_INDEX.lock().unwrap();
    let search_index = search_index_guard.as_mut().ok_or(
        "검색 인덱스가 초기화되지 않았습니다. initialize_search_index()를 먼저 호출하세요.",
    )?;

    // create index writer with explicit type
    let mut index_writer: tantivy::IndexWriter = search_index
        .index
        .writer(50_000_000)
        .map_err(|e| e.to_string())?;

    // 모든 문서 삭제 - delete_all_documents()를 stampede로 실행
    let _ = index_writer.delete_all_documents();

    // commit
    index_writer.commit().map_err(|e| e.to_string())?;

    Ok("모든 문서가 삭제되었습니다.".to_string())
}

/// 인덱스에 있는 문서 개수를 반환합니다
#[flutter_rust_bridge::frb(sync)]
pub fn get_document_count() -> Result<u64, String> {
    let search_index = SEARCH_INDEX.lock().unwrap();
    let search_index = search_index.as_ref().ok_or(
        "검색 인덱스가 초기화되지 않았습니다. initialize_search_index()를 먼저 호출하세요.",
    )?;

    let reader = search_index.index.reader().map_err(|e| e.to_string())?;
    let searcher = reader.searcher();

    Ok(searcher.num_docs())
}

// 여러 문서 추가를 위한 입력 구조체
#[derive(Clone, Debug)]
pub struct DocumentInput {
    pub id: String,
    pub title: String,
    pub body: String,
    pub metadata: String, // JSON string
}

// UUID 생성 헬퍼 함수
fn generate_uuid() -> String {
    use std::sync::atomic::{AtomicU64, Ordering};
    use std::time::{SystemTime, UNIX_EPOCH};

    static COUNTER: AtomicU64 = AtomicU64::new(0);

    let timestamp = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap()
        .as_micros();

    let counter = COUNTER.fetch_add(1, Ordering::SeqCst);

    format!("{:016x}-{:08x}", timestamp, counter)
}
