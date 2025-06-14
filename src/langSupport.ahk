/*
Mesut Akcan
makcan@gmail.com
akcansoft.blogspot.com
mesutakcan.blogspot.com
github.com/akcansoft
youtube.com/mesutakcan
*/

; https://www.autohotkey.com/docs/v2/misc/Languages.htm

LCID := Map(
  "0036", "af", ; Afrikaans
  "0436", "af-ZA", ; Afrikaans (South Africa)
  "001C", "sq", ; Albanian
  "041C", "sq-AL", ; Albanian (Albania)
  "0484", "gsw-FR", ; Alsatian (France)
  "005E", "am", ; Amharic
  "045E", "am-ET", ; Amharic (Ethiopia)
  "0001", "ar", ; Arabic
  "1401", "ar-DZ", ; Arabic (Algeria)
  "3C01", "ar-BH", ; Arabic (Bahrain)
  "0C01", "ar-EG", ; Arabic (Egypt)
  "0801", "ar-IQ", ; Arabic (Iraq)
  "2C01", "ar-JO", ; Arabic (Jordan)
  "3401", "ar-KW", ; Arabic (Kuwait)
  "3001", "ar-LB", ; Arabic (Lebanon)
  "1001", "ar-LY", ; Arabic (Libya)
  "1801", "ar-MA", ; Arabic (Morocco)
  "2001", "ar-OM", ; Arabic (Oman)
  "4001", "ar-QA", ; Arabic (Qatar)
  "0401", "ar-SA", ; Arabic (Saudi Arabia)
  "2801", "ar-SY", ; Arabic (Syria)
  "1C01", "ar-TN", ; Arabic (Tunisia)
  "3801", "ar-AE", ; Arabic (United Arab Emirates)
  "2401", "ar-YE", ; Arabic (Yemen)
  "002B", "hy", ; Armenian
  "042B", "hy-AM", ; Armenian (Armenia)
  "004D", "as", ; Assamese
  "044D", "as-IN", ; Assamese (India)
  "002C", "az", ; Azerbaijani
  "742C", "az-Cyrl", ; Azerbaijani (Cyrillic)
  "082C", "az-Cyrl-AZ", ; Azerbaijani (Cyrillic, Azerbaijan)
  "782C", "az-Latn", ; Azerbaijani (Latin)
  "042C", "az-Latn-AZ", ; Azerbaijani (Latin, Azerbaijan)
  "0045", "bn", ; Bangla
  "0845", "bn-BD", ; Bangla (Bangladesh)
  "006D", "ba", ; Bashkir
  "046D", "ba-RU", ; Bashkir (Russia)
  "002D", "eu", ; Basque
  "042D", "eu-ES", ; Basque (Basque)
  "0023", "be", ; Belarusian
  "0423", "be-BY", ; Belarusian (Belarus)
  "0445", "bn-IN", ; Bengali (India)
  "781A", "bs", ; Bosnian
  "641A", "bs-Cyrl", ; Bosnian (Cyrillic)
  "201A", "bs-Cyrl-BA", ; Bosnian (Cyrillic, Bosnia and Herzegovina)
  "681A", "bs-Latn", ; Bosnian (Latin)
  "141A", "bs-Latn-BA", ; Bosnian (Latin, Bosnia & Herzegovina)
  "007E", "br", ; Breton
  "047E", "br-FR", ; Breton (France)
  "0002", "bg", ; Bulgarian
  "0402", "bg-BG", ; Bulgarian (Bulgaria)
  "0055", "my", ; Burmese
  "0455", "my-MM", ; Burmese (Myanmar)
  "0003", "ca", ; Catalan
  "0403", "ca-ES", ; Catalan (Catalan)
  "005F", "tzm", ; Central Atlas Tamazight
  "045F", "tzm-Arab-MA", ; Central Atlas Tamazight (Arabic, Morocco)
  "7C5F", "tzm-Latn", ; Central Atlas Tamazight (Latin)
  "085F", "tzm-Latn-DZ", ; Central Atlas Tamazight (Latin, Algeria)
  "785F", "tzm-Tfng", ; Central Atlas Tamazight (Tifinagh)
  "105F", "tzm-Tfng-MA", ; Central Atlas Tamazight (Tifinagh, Morocco)
  "0092", "ku", ; Central Kurdish
  "7C92", "ku-Arab", ; Central Kurdish
  "0492", "ku-Arab-IQ", ; Central Kurdish (Iraq)
  "005C", "chr", ; Cherokee
  "7C5C", "chr-Cher", ; Cherokee
  "045C", "chr-Cher-US", ; Cherokee (Cherokee, United States)
  "7804", "zh", ; Chinese
  "0004", "zh-Hans", ; Chinese (Simplified)
  "0804", "zh-CN", ; Chinese (Simplified, China)
  "1004", "zh-SG", ; Chinese (Simplified, Singapore)
  "7C04", "zh-Hant", ; Chinese (Traditional)
  "0C04", "zh-HK", ; Chinese (Traditional, Hong Kong SAR)
  "1404", "zh-MO", ; Chinese (Traditional, Macao SAR)
  "0404", "zh-TW", ; Chinese (Traditional, Taiwan)
  "0083", "co", ; Corsican
  "0483", "co-FR", ; Corsican (France)
  "001A", "hr", ; Croatian
  "101A", "hr-BA", ; Croatian (Bosnia & Herzegovina)
  "041A", "hr-HR", ; Croatian (Croatia)
  "0005", "cs", ; Czech
  "0405", "cs-CZ", ; Czech (Czechia)
  "0006", "da", ; Danish
  "0406", "da-DK", ; Danish (Denmark)
  "0065", "dv", ; Divehi
  "0465", "dv-MV", ; Divehi (Maldives)
  "0013", "nl", ; Dutch
  "0813", "nl-BE", ; Dutch (Belgium)
  "0413", "nl-NL", ; Dutch (Netherlands)
  "0C51", "dz-BT", ; Dzongkha (Bhutan)
  "0066", "bin", ; Edo
  "0466", "bin-NG", ; Edo (Nigeria)
  "0009", "en", ; English
  "0C09", "en-AU", ; English (Australia)
  "2809", "en-BZ", ; English (Belize)
  "1009", "en-CA", ; English (Canada)
  "2409", "en-029", ; English (Caribbean)
  "3C09", "en-HK", ; English (Hong Kong SAR)
  "4009", "en-IN", ; English (India)
  "3809", "en-ID", ; English (Indonesia)
  "1809", "en-IE", ; English (Ireland)
  "2009", "en-JM", ; English (Jamaica)
  "4409", "en-MY", ; English (Malaysia)
  "1409", "en-NZ", ; English (New Zealand)
  "3409", "en-PH", ; English (Philippines)
  "4809", "en-SG", ; English (Singapore)
  "1C09", "en-ZA", ; English (South Africa)
  "2C09", "en-TT", ; English (Trinidad & Tobago)
  "4C09", "en-AE", ; English (United Arab Emirates)
  "0809", "en-GB", ; English (United Kingdom)
  "0409", "en-US", ; English (United States)
  "3009", "en-ZW", ; English (Zimbabwe)
  "0025", "et", ; Estonian
  "0425", "et-EE", ; Estonian (Estonia)
  "0038", "fo", ; Faroese
  "0438", "fo-FO", ; Faroese (Faroe Islands)
  "0064", "fil", ; Filipino
  "0464", "fil-PH", ; Filipino (Philippines)
  "000B", "fi", ; Finnish
  "040B", "fi-FI", ; Finnish (Finland)
  "000C", "fr", ; French
  "080C", "fr-BE", ; French (Belgium)
  "2C0C", "fr-CM", ; French (Cameroon)
  "0C0C", "fr-CA", ; French (Canada)
  "1C0C", "fr-029", ; French (Caribbean)
  "300C", "fr-CI", ; French (Côte d’Ivoire)
  "040C", "fr-FR", ; French (France)
  "3C0C", "fr-HT", ; French (Haiti)
  "140C", "fr-LU", ; French (Luxembourg)
  "340C", "fr-ML", ; French (Mali)
  "180C", "fr-MC", ; French (Monaco)
  "380C", "fr-MA", ; French (Morocco)
  "200C", "fr-RE", ; French (Réunion)
  "280C", "fr-SN", ; French (Senegal)
  "100C", "fr-CH", ; French (Switzerland)
  "240C", "fr-CD", ; French Congo (DRC)
  "0067", "ff", ; Fulah
  "7C67", "ff-Latn", ; Fulah (Latin)
  "0467", "ff-Latn-NG", ; Fulah (Latin, Nigeria)
  "0867", "ff-Latn-SN", ; Fulah (Latin, Senegal)
  "0056", "gl", ; Galician
  "0456", "gl-ES", ; Galician (Galician)
  "0037", "ka", ; Georgian
  "0437", "ka-GE", ; Georgian (Georgia)
  "0007", "de", ; German
  "0C07", "de-AT", ; German (Austria)
  "0407", "de-DE", ; German (Germany)
  "1407", "de-LI", ; German (Liechtenstein)
  "1007", "de-LU", ; German (Luxembourg)
  "0807", "de-CH", ; German (Switzerland)
  "0008", "el", ; Greek
  "0408", "el-GR", ; Greek (Greece)
  "0074", "gn", ; Guarani
  "0474", "gn-PY", ; Guarani (Paraguay)
  "0047", "gu", ; Gujarati
  "0447", "gu-IN", ; Gujarati (India)
  "0068", "ha", ; Hausa
  "7C68", "ha-Latn", ; Hausa (Latin)
  "0468", "ha-Latn-NG", ; Hausa (Latin, Nigeria)
  "0075", "haw", ; Hawaiian
  "0475", "haw-US", ; Hawaiian (United States)
  "000D", "he", ; Hebrew
  "040D", "he-IL", ; Hebrew (Israel)
  "0039", "hi", ; Hindi
  "0439", "hi-IN", ; Hindi (India)
  "000E", "hu", ; Hungarian
  "040E", "hu-HU", ; Hungarian (Hungary)
  "0069", "ibb", ; Ibibio
  "0469", "ibb-NG", ; Ibibio (Nigeria)
  "000F", "is", ; Icelandic
  "040F", "is-IS", ; Icelandic (Iceland)
  "0070", "ig", ; Igbo
  "0470", "ig-NG", ; Igbo (Nigeria)
  "0021", "id", ; Indonesian
  "0421", "id-ID", ; Indonesian (Indonesia)
  "005D", "iu", ; Inuktitut
  "7C5D", "iu-Latn", ; Inuktitut (Latin)
  "085D", "iu-Latn-CA", ; Inuktitut (Latin, Canada)
  "785D", "iu-Cans", ; Inuktitut (Syllabics)
  "045D", "iu-Cans-CA", ; Inuktitut (Syllabics, Canada)
  "003C", "ga", ; Irish
  "083C", "ga-IE", ; Irish (Ireland)
  "0034", "xh", ; isiXhosa
  "0434", "xh-ZA", ; isiXhosa (South Africa)
  "0035", "zu", ; isiZulu
  "0435", "zu-ZA", ; isiZulu (South Africa)
  "0010", "it", ; Italian
  "0410", "it-IT", ; Italian (Italy)
  "0810", "it-CH", ; Italian (Switzerland)
  "0011", "ja", ; Japanese
  "0411", "ja-JP", ; Japanese (Japan)
  "006F", "kl", ; Kalaallisut
  "046F", "kl-GL", ; Kalaallisut (Greenland)
  "004B", "kn", ; Kannada
  "044B", "kn-IN", ; Kannada (India)
  "0071", "kr", ; Kanuri
  "0471", "kr-Latn-NG", ; Kanuri (Latin, Nigeria)
  "0060", "ks", ; Kashmiri
  "0460", "ks-Arab", ; Kashmiri (Arabic)
  "1000", "ks-Arab-IN", ; Kashmiri (Arabic)
  "0860", "ks-Deva-IN", ; Kashmiri (Devanagari)
  "003F", "kk", ; Kazakh
  "043F", "kk-KZ", ; Kazakh (Kazakhstan)
  "0053", "km", ; Khmer
  "0453", "km-KH", ; Khmer (Cambodia)
  "0087", "rw", ; Kinyarwanda
  "0487", "rw-RW", ; Kinyarwanda (Rwanda)
  "0041", "sw", ; Kiswahili
  "0441", "sw-KE", ; Kiswahili (Kenya)
  "0057", "kok", ; Konkani
  "0457", "kok-IN", ; Konkani (India)
  "0012", "ko", ; Korean
  "0412", "ko-KR", ; Korean (Korea)
  "0040", "ky", ; Kyrgyz
  "0440", "ky-KG", ; Kyrgyz (Kyrgyzstan)
  "0086", "quc", ; Kʼicheʼ
  "7C86", "quc-Latn", ; Kʼicheʼ (Latin)
  "0486", "quc-Latn-GT", ; Kʼicheʼ (Latin, Guatemala)
  "0054", "lo", ; Lao
  "0454", "lo-LA", ; Lao (Laos)
  "0076", "la", ; Latin
  "0476", "la-VA", ; Latin (Vatican City)
  "0026", "lv", ; Latvian
  "0426", "lv-LV", ; Latvian (Latvia)
  "0027", "lt", ; Lithuanian
  "0427", "lt-LT", ; Lithuanian (Lithuania)
  "7C2E", "dsb", ; Lower Sorbian
  "082E", "dsb-DE", ; Lower Sorbian (Germany)
  "006E", "lb", ; Luxembourgish
  "046E", "lb-LU", ; Luxembourgish (Luxembourg)
  "002F", "mk", ; Macedonian
  "042F", "mk-MK", ; Macedonian (North Macedonia)
  "003E", "ms", ; Malay
  "083E", "ms-BN", ; Malay (Brunei)
  "043E", "ms-MY", ; Malay (Malaysia)
  "004C", "ml", ; Malayalam
  "044C", "ml-IN", ; Malayalam (India)
  "003A", "mt", ; Maltese
  "043A", "mt-MT", ; Maltese (Malta)
  "0058", "mni", ; Manipuri
  "0458", "mni-IN", ; Manipuri (Bangla, India)
  "0081", "mi", ; Maori
  "0481", "mi-NZ", ; Maori (New Zealand)
  "007A", "arn", ; Mapuche
  "047A", "arn-CL", ; Mapuche (Chile)
  "004E", "mr", ; Marathi
  "044E", "mr-IN", ; Marathi (India)
  "007C", "moh", ; Mohawk
  "047C", "moh-CA", ; Mohawk (Canada)
  "0050", "mn", ; Mongolian
  "7850", "mn-Cyrl", ; Mongolian
  "0450", "mn-MN", ; Mongolian (Mongolia)
  "7C50", "mn-Mong", ; Mongolian (Traditional Mongolian)
  "0850", "mn-Mong-CN", ; Mongolian (Traditional Mongolian, China)
  "0C50", "mn-Mong-MN", ; Mongolian (Traditional Mongolian, Mongolia)
  "0061", "ne", ; Nepali
  "0861", "ne-IN", ; Nepali (India)
  "0461", "ne-NP", ; Nepali (Nepal)
  "003B", "se", ; Northern Sami
  "0014", "no", ; Norwegian
  "7C14", "nb", ; Norwegian Bokmål
  "0414", "nb-NO", ; Norwegian Bokmål (Norway)
  "7814", "nn", ; Norwegian Nynorsk
  "0814", "nn-NO", ; Norwegian Nynorsk (Norway)
  "0082", "oc", ; Occitan
  "0482", "oc-FR", ; Occitan (France)
  "0048", "or", ; Odia
  "0448", "or-IN", ; Odia (India)
  "0072", "om", ; Oromo
  "0472", "om-ET", ; Oromo (Ethiopia)
  "0079", "pap", ; Papiamento
  "0479", "pap-029", ; Papiamento (Caribbean)
  "0063", "ps", ; Pashto
  "0463", "ps-AF", ; Pashto (Afghanistan)
  "0029", "fa", ; Persian
  "008C", "fa", ; Persian
  "048C", "fa-AF", ; Persian (Afghanistan)
  "0429", "fa-IR", ; Persian (Iran)
  "0015", "pl", ; Polish
  "0415", "pl-PL", ; Polish (Poland)
  "0016", "pt", ; Portuguese
  "0416", "pt-BR", ; Portuguese (Brazil)
  "0816", "pt-PT", ; Portuguese (Portugal)
  "05FE", "qps-ploca", ; Pseudo (Pseudo Asia)
  "09FF", "qps-plocm", ; Pseudo (Pseudo Mirrored)
  "0901", "qps-Latn-x-sh", ; Pseudo (Pseudo Selfhost)
  "0501", "qps-ploc", ; Pseudo (Pseudo)
  "0046", "pa", ; Punjabi
  "7C46", "pa-Arab", ; Punjabi
  "0446", "pa-IN", ; Punjabi (India)
  "0846", "pa-Arab-PK", ; Punjabi (Pakistan)
  "006B", "quz", ; Quechua
  "046B", "quz-BO", ; Quechua (Bolivia)
  "086B", "quz-EC", ; Quechua (Ecuador)
  "0C6B", "quz-PE", ; Quechua (Peru)
  "0018", "ro", ; Romanian
  "0818", "ro-MD", ; Romanian (Moldova)
  "0418", "ro-RO", ; Romanian (Romania)
  "0017", "rm", ; Romansh
  "0417", "rm-CH", ; Romansh (Switzerland)
  "0019", "ru", ; Russian
  "0819", "ru-MD", ; Russian (Moldova)
  "0419", "ru-RU", ; Russian (Russia)
  "0085", "sah", ; Sakha
  "0485", "sah-RU", ; Sakha (Russia)
  "703B", "smn", ; Sami (Inari)
  "7C3B", "smj", ; Sami (Lule)
  "743B", "sms", ; Sami (Skolt)
  "783B", "sma", ; Sami (Southern)
  "243B", "smn-FI", ; Sami, Inari (Finland)
  "103B", "smj-NO", ; Sami, Lule (Norway)
  "143B", "smj-SE", ; Sami, Lule (Sweden)
  "0C3B", "se-FI", ; Sami, Northern (Finland)
  "043B", "se-NO", ; Sami, Northern (Norway)
  "083B", "se-SE", ; Sami, Northern (Sweden)
  "203B", "sms-FI", ; Sami, Skolt (Finland)
  "183B", "sma-NO", ; Sami, Southern (Norway)
  "1C3B", "sma-SE", ; Sami, Southern (Sweden)
  "004F", "sa", ; Sanskrit
  "044F", "sa-IN", ; Sanskrit (India)
  "0091", "gd", ; Scottish Gaelic
  "0491", "gd-GB", ; Scottish Gaelic (United Kingdom)
  "7C1A", "sr", ; Serbian
  "6C1A", "sr-Cyrl", ; Serbian (Cyrillic)
  "1C1A", "sr-Cyrl-BA", ; Serbian (Cyrillic, Bosnia and Herzegovina)
  "301A", "sr-Cyrl-ME", ; Serbian (Cyrillic, Montenegro)
  "0C1A", "sr-Cyrl-CS", ; Serbian (Cyrillic, Serbia and Montenegro (Former))
  "281A", "sr-Cyrl-RS", ; Serbian (Cyrillic, Serbia)
  "701A", "sr-Latn", ; Serbian (Latin)
  "181A", "sr-Latn-BA", ; Serbian (Latin, Bosnia & Herzegovina)
  "2C1A", "sr-Latn-ME", ; Serbian (Latin, Montenegro)
  "081A", "sr-Latn-CS", ; Serbian (Latin, Serbia and Montenegro (Former))
  "241A", "sr-Latn-RS", ; Serbian (Latin, Serbia)
  "0030", "st", ; Sesotho
  "0430", "st-ZA", ; Sesotho (South Africa)
  "006C", "nso", ; Sesotho sa Leboa
  "046C", "nso-ZA", ; Sesotho sa Leboa (South Africa)
  "0032", "tn", ; Setswana
  "0832", "tn-BW", ; Setswana (Botswana)
  "0432", "tn-ZA", ; Setswana (South Africa)
  "0059", "sd", ; Sindhi
  "7C59", "sd-Arab", ; Sindhi
  "0459", "sd-Deva-IN", ; Sindhi (Devanagari, India)
  "0859", "sd-Arab-PK", ; Sindhi (Pakistan)
  "005B", "si", ; Sinhala
  "045B", "si-LK", ; Sinhala (Sri Lanka)
  "001B", "sk", ; Slovak
  "041B", "sk-SK", ; Slovak (Slovakia)
  "0024", "sl", ; Slovenian
  "0424", "sl-SI", ; Slovenian (Slovenia)
  "0077", "so", ; Somali
  "0477", "so-SO", ; Somali (Somalia)
  "000A", "es", ; Spanish
  "2C0A", "es-AR", ; Spanish (Argentina)
  "400A", "es-BO", ; Spanish (Bolivia)
  "340A", "es-CL", ; Spanish (Chile)
  "240A", "es-CO", ; Spanish (Colombia)
  "140A", "es-CR", ; Spanish (Costa Rica)
  "5C0A", "es-CU", ; Spanish (Cuba)
  "1C0A", "es-DO", ; Spanish (Dominican Republic)
  "300A", "es-EC", ; Spanish (Ecuador)
  "440A", "es-SV", ; Spanish (El Salvador)
  "100A", "es-GT", ; Spanish (Guatemala)
  "480A", "es-HN", ; Spanish (Honduras)
  "580A", "es-419", ; Spanish (Latin America)
  "080A", "es-MX", ; Spanish (Mexico)
  "4C0A", "es-NI", ; Spanish (Nicaragua)
  "180A", "es-PA", ; Spanish (Panama)
  "3C0A", "es-PY", ; Spanish (Paraguay)
  "280A", "es-PE", ; Spanish (Peru)
  "500A", "es-PR", ; Spanish (Puerto Rico)
  "0C0A", "es-ES", ; Spanish (Spain, International Sort)
  "040A", "es-ES_tradnl", ; Spanish (Spain, Traditional Sort)
  "540A", "es-US", ; Spanish (United States)
  "380A", "es-UY", ; Spanish (Uruguay)
  "200A", "es-VE", ; Spanish (Venezuela)
  "001D", "sv", ; Swedish
  "081D", "sv-FI", ; Swedish (Finland)
  "041D", "sv-SE", ; Swedish (Sweden)
  "0084", "gsw", ; Swiss German
  "005A", "syr", ; Syriac
  "045A", "syr-SY", ; Syriac (Syria)
  "0028", "tg", ; Tajik
  "7C28", "tg-Cyrl", ; Tajik (Cyrillic)
  "0428", "tg-Cyrl-TJ", ; Tajik (Cyrillic, Tajikistan)
  "0049", "ta", ; Tamil
  "0449", "ta-IN", ; Tamil (India)
  "0849", "ta-LK", ; Tamil (Sri Lanka)
  "0044", "tt", ; Tatar
  "0444", "tt-RU", ; Tatar (Russia)
  "004A", "te", ; Telugu
  "044A", "te-IN", ; Telugu (India)
  "001E", "th", ; Thai
  "041E", "th-TH", ; Thai (Thailand)
  "0051", "bo", ; Tibetan
  "0451", "bo-CN", ; Tibetan (China)
  "0073", "ti", ; Tigrinya
  "0873", "ti-ER", ; Tigrinya (Eritrea)
  "0473", "ti-ET", ; Tigrinya (Ethiopia)
  "001F", "tr", ; Turkish
  "041F", "tr-TR", ; Turkish (Turkey)
  "0042", "tk", ; Turkmen
  "0442", "tk-TM", ; Turkmen (Turkmenistan)
  "0022", "uk", ; Ukrainian
  "0422", "uk-UA", ; Ukrainian (Ukraine)
  "002E", "hsb", ; Upper Sorbian
  "042E", "hsb-DE", ; Upper Sorbian (Germany)
  "0020", "ur", ; Urdu
  "0820", "ur-IN", ; Urdu (India)
  "0420", "ur-PK", ; Urdu (Pakistan)
  "0080", "ug", ; Uyghur
  "0480", "ug-CN", ; Uyghur (China)
  "0043", "uz", ; Uzbek
  "7843", "uz-Cyrl", ; Uzbek (Cyrillic)
  "0843", "uz-Cyrl-UZ", ; Uzbek (Cyrillic, Uzbekistan)
  "7C43", "uz-Latn", ; Uzbek (Latin)
  "0443", "uz-Latn-UZ", ; Uzbek (Latin, Uzbekistan)
  "0803", "ca-ES-valencia", ; Valencian (Spain)
  "0033", "ve", ; Venda
  "0433", "ve-ZA", ; Venda (South Africa)
  "002A", "vi", ; Vietnamese
  "042A", "vi-VN", ; Vietnamese (Vietnam)
  "0052", "cy", ; Welsh
  "0452", "cy-GB", ; Welsh (United Kingdom)
  "0062", "fy", ; Western Frisian
  "0462", "fy-NL", ; Western Frisian (Netherlands)
  "0088", "wo", ; Wolof
  "0488", "wo-SN", ; Wolof (Senegal)
  "0031", "ts", ; Xitsonga
  "0431", "ts-ZA", ; Xitsonga (South Africa)
  "0078", "ii", ; Yi
  "0478", "ii-CN", ; Yi (China)
  "003D", "yi", ; Yiddish
  "043D", "yi-001", ; Yiddish (World)
  "006A", "yo", ; Yoruba
  "046A", "yo-NG" ; Yoruba (Nigeria)
)

; Load language based on system language
LoadLanguage() {
  global lang := Map() ; Language strings
  langDir := A_ScriptDir "\lang\" ; Language directory
  if !FileExist(langDir) { ; Check if the language directory exists
    MsgBox("Language directory not found: " langDir)
    ExitApp()
  }
  langID := LCID[A_Language] ; Get the system language LCID
  langFile := langDir langID ".ini" ; Try system language first
  if !FileExist(langFile){ ; If system language file doesn't exist
    langFile := langDir StrSplit(langID, "-")[1] ".ini" ; Try base language
    if !FileExist(langFile){ ; If base language file doesn't exist
      langFile := langDir "en.ini" ; Try English
      if !FileExist(langFile) { ; If no language file exists
        MsgBox("Default language file not found in: " langDir)
        ExitApp()
      }
    }
  }

  ; Read all sections from INI file into lang Map
  for section in ["Menu", "File", "Shortcuts", "FileInfo", "About"] { ; Read each section
    sectionContent := IniRead(langFile, section) ; Read the section content
    keys := StrSplit(sectionContent, "`n")
    for key in keys { ; Read each key-value pair
      key := Trim(key) ; Remove leading and trailing whitespace
      if (key != "") { ; Check if the key is not empty
        ; Split the key into name and value
        parts := StrSplit(key, "=", , 2)
        if (parts.Length = 2) ; Check if the split was successful
          lang[section "_" parts[1]] := parts[2] ; Store the key-value pair in the lang Map
      }
    }
  }  
}

