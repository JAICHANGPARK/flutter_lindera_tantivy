//! This module provides enums and functions that define various data structures,
//! and utilities to work with them.
//!
//! # Enums
//!
//! ## Dictionary
//! Represents various dictionary types:
//! - `Korean`: Refers to Korean dictionary (`ko-dic`).
//! - `JapaneseIpadic`: Refers to Japanese IPAdic dictionary (`ipadic`).
//! - `JapaneseUnidic`: Refers to Japanese UniDic dictionary (`unidic`).
//! - `Chinese`: Refers to Chinese dictionary (`cc-cedict`).
//!
//! ## Weekdays
//! Represents the days of the week:
//! - `Monday`
//! - `Tuesday`
//! - `Wednesday`
//! - `Thursday`
//! - `Friday`
//! - `Saturday`
//! - `Sunday`
//!
//! ## KitchenSink
//! Represents a complex enum containing various variants:
//! - `Empty`: An empty state.
//! - `Primitives`: Contains fields for basic types:
//!   - `int32`: A 32-bit integer.
//!   - `float64`: A 64-bit floating-point number.
//!   - `boolean`: A boolean value.
//! - `Nested`: A variant containing a nested `Box<KitchenSink>` enum.
//! - `Optional`: A tuple variant containing optional 32-bit integers:
//!   - The first field is optional and refers to `i32`.
//!   - The second field is optional and refers to `i32`.
//! - `Buffer`: Contains a `ZeroCopyBuffer` wrapping a `Vec<u8>`.
//! - `Enums`: Represents a variant
use flutter_rust_bridge::ZeroCopyBuffer;

pub enum Dictionary {
    Korean,                 // ko-dic
    JapaneseIpadic,        // ipadic
    // JapaneseIpadicNeologd, // ipadic-neologd
    JapaneseUnidic,        // unidic
    Chinese,               // cc-cedict
}

pub enum Weekdays {
    Monday,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Saturday,
    Sunday,
}

pub enum KitchenSink {
    Empty,
    Primitives {
        /// Dart field comment
        int32: i32,
        float64: f64,
        boolean: bool,
    },
    Nested(Box<KitchenSink>),
    Optional(
        /// Comment on anonymous field
        Option<i32>,
        Option<i32>,
    ),
    Buffer(ZeroCopyBuffer<Vec<u8>>),
    Enums(Weekdays),
}

