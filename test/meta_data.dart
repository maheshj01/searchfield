/*
 * File: meta_data.dart
 * Project: searchfield
 * File Created: Saturday, 16th April 2022 6:04:04 pm
 * Author: Mahesh Jamdade
 * -----
 * Last Modified: Saturday, 16th April 2022 6:07:00 pm
 * Modified By: Mahesh Jamdade
 * -----
 * Copyright 2022 - 2022 Widget Media Labs
 */

class Country {
  final String name;
  final int population;
  final int landArea;
  final int density;
  Country(this.name, this.population, this.landArea, this.density);

  Country.init()
      : name = '',
        population = 0,
        landArea = 0,
        density = 0;

  Country.fromMap(Map<String, Object> map)
      : name = map['country'] as String,
        population = map['population'] as int,
        landArea = map['land Area'] as int,
        density = map['density'] as int;
}

List<Map<String, Object>> data = [
  {
    'country': 'Afghanistan',
    'population': 38928346,
    'density': 60,
    'land Area': 652860
  },
  {
    'country': 'Albania',
    'population': 2877797,
    'density': 105,
    'land Area': 27400
  },
  {
    'country': 'Algeria',
    'population': 43851044,
    'density': 18,
    'land Area': 2381740
  },
  {'country': 'Andorra', 'population': 77265, 'density': 164, 'land Area': 470},
  {
    'country': 'Angola',
    'population': 32866272,
    'density': 26,
    'land Area': 1246700
  },
  {
    'country': 'Antigua and Barbuda',
    'population': 97929,
    'density': 223,
    'land Area': 440
  },
  {
    'country': 'Argentina',
    'population': 45195774,
    'density': 17,
    'land Area': 2736690
  },
  {
    'country': 'Armenia',
    'population': 2963243,
    'density': 104,
    'land Area': 28470
  },
  {
    'country': 'Australia',
    'population': 25499884,
    'density': 3,
    'land Area': 7682300
  },
  {
    'country': 'Austria',
    'population': 9006398,
    'density': 109,
    'land Area': 82409
  },
  {
    'country': 'Azerbaijan',
    'population': 10139177,
    'density': 123,
    'land Area': 82658
  },
  {
    'country': 'Bahamas',
    'population': 393244,
    'density': 39,
    'land Area': 10010
  },
  {
    'country': 'Bahrain',
    'population': 1701575,
    'density': 2239,
    'land Area': 760
  },
  {
    'country': 'Bangladesh',
    'population': 164689383,
    'density': 1265,
    'land Area': 130170
  },
  {
    'country': 'Barbados',
    'population': 287375,
    'density': 668,
    'land Area': 430
  },
  {
    'country': 'Belarus',
    'population': 9449323,
    'density': 47,
    'land Area': 202910
  },
  {
    'country': 'Belgium',
    'population': 11589623,
    'density': 383,
    'land Area': 30280
  },
  {
    'country': 'Belize',
    'population': 397628,
    'density': 17,
    'land Area': 22810
  },
  {
    'country': 'Benin',
    'population': 12123200,
    'density': 108,
    'land Area': 112760
  },
  {
    'country': 'Bhutan',
    'population': 771608,
    'density': 20,
    'land Area': 38117
  },
  {
    'country': 'Bolivia',
    'population': 11673021,
    'density': 11,
    'land Area': 1083300
  },
  {
    'country': 'Bosnia and Herzegovina',
    'population': 3280819,
    'density': 64,
    'land Area': 51000
  },
  {
    'country': 'Botswana',
    'population': 2351627,
    'density': 4,
    'land Area': 566730
  },
  {
    'country': 'Brazil',
    'population': 212559417,
    'density': 25,
    'land Area': 8358140
  },
  {'country': 'Brunei', 'population': 437479, 'density': 83, 'land Area': 5270},
  {
    'country': 'Bulgaria',
    'population': 6948445,
    'density': 64,
    'land Area': 108560
  },
  {
    'country': 'Burkina Faso',
    'population': 20903273,
    'density': 76,
    'land Area': 273600
  },
  {
    'country': 'Burundi',
    'population': 1890784,
    'density': 463,
    'land Area': 25680
  },
  {
    'country': 'Côte d\'Ivoire',
    'population': 26378274,
    'density': 83,
    'land Area': 318000
  },
  {
    'country': 'Cabo Verde',
    'population': 555987,
    'density': 138,
    'land Area': 4030
  },
  {
    'country': 'Cambodia',
    'population': 16718965,
    'density': 95,
    'land Area': 176520
  },
  {
    'country': 'Cameroon',
    'population': 26545863,
    'density': 56,
    'land Area': 472710
  },
  {
    'country': 'Canada',
    'population': 37742154,
    'density': 4,
    'land Area': 9093510
  },
  {
    'country': 'Central African Republic',
    'population': 4829767,
    'density': 8,
    'land Area': 622980
  },
  {
    'country': 'Chad',
    'population': 16425864,
    'density': 13,
    'land Area': 1259200
  },
  {
    'country': 'Chile',
    'population': 19116201,
    'density': 26,
    'land Area': 743532
  },
  {
    'country': 'China',
    'population': 1439323776,
    'density': 153,
    'land Area': 9388211
  },
  {
    'country': 'Colombia',
    'population': 50882891,
    'density': 46,
    'land Area': 1109500
  },
  {
    'country': 'Comoros',
    'population': 869601,
    'density': 467,
    'land Area': 1861
  },
  {
    'country': 'Congo (Congo-Brazzaville)',
    'population': 5518087,
    'density': 16,
    'land Area': 341500
  },
  {
    'country': 'Costa Rica',
    'population': 5094118,
    'density': 100,
    'land Area': 51060
  },
  {
    'country': 'Croatia',
    'population': 4105267,
    'density': 73,
    'land Area': 55960
  },
  {
    'country': 'Cuba',
    'population': 11326616,
    'density': 106,
    'land Area': 106440
  },
  {
    'country': 'Cyprus',
    'population': 1207359,
    'density': 131,
    'land Area': 9240
  },
  {
    'country': 'Czechia (Czech Republic)',
    'population': 10708981,
    'density': 139,
    'land Area': 77240
  },
  {
    'country': 'Democratic Republic of the Congo',
    'population': 89561403,
    'density': 40,
    'land Area': 2267050
  },
  {
    'country': 'Denmark',
    'population': 5792202,
    'density': 137,
    'land Area': 42430
  },
  {
    'country': 'Djibouti',
    'population': 988000,
    'density': 43,
    'land Area': 23180
  },
  {'country': 'Dominica', 'population': 71986, 'density': 96, 'land Area': 750},
  {
    'country': 'Dominican Republic',
    'population': 10847910,
    'density': 225,
    'land Area': 483202
  },
  {
    'country': 'Ecuador',
    'population': 17643054,
    'density': 71,
    'land Area': 248360
  },
  {
    'country': 'Egypt',
    'population': 102334404,
    'density': 103,
    'land Area': 995450
  },
  {
    'country': 'El Salvador	',
    'population': 6486205,
    'density': 313,
    'land Area': 20720
  },
  {
    'country': 'Equatorial Guinea',
    'population': 1402985,
    'density': 50,
    'land Area': 28050
  },
  {
    'country': 'Eritrea',
    'population': 3546421,
    'density': 35,
    'land Area': 101000
  },
  {
    'country': 'Estonia',
    'population': 1326535,
    'density': 31,
    'land Area': 42390
  },
  {
    'country': 'Eswatini (fmr. Swaziland)',
    'population': 1160164,
    'density': 67,
    'land Area': 17200
  },
  {
    'country': 'Ethiopia',
    'population': 114963588,
    'density': 115,
    'land Area': 1000000
  },
  {'country': 'Fiji', 'population': 896445, 'density': 49, 'land Area': 18270},
  {
    'country': 'Finland',
    'population': 5540720,
    'density': 18,
    'land Area': 303890
  },
  {
    'country': 'France',
    'population': 65273511,
    'density': 119,
    'land Area': 547557
  },
  {
    'country': 'Gabon',
    'population': 2225734,
    'density': 9,
    'land Area': 257670
  },
  {
    'country': 'Gambia',
    'population': 2416668,
    'density': 239,
    'land Area': 10120
  },
  {
    'country': 'Georgia',
    'population': 3989167,
    'density': 57,
    'land Area': 69490
  },
  {
    'country': 'Germany',
    'population': 83783942,
    'density': 240,
    'land Area': 348560
  },
  {
    'country': 'Ghana',
    'population': 31072940,
    'density': 137,
    'land Area': 227540
  },
  {
    'country': 'Greece',
    'population': 10423054,
    'density': 81,
    'land Area': 128900
  },
  {
    'country': 'Grenada',
    'population': 112523,
    'density': 331,
    'land Area': 340
  },
  {
    'country': 'Guatemala',
    'population': 17915568,
    'density': 167,
    'land Area': 107160
  },
  {
    'country': 'Guinea',
    'population': 13132795,
    'density': 53,
    'land Area': 245720
  },
  {
    'country': 'Guinea Bissau',
    'population': 1968001,
    'density': 70,
    'land Area': 28120
  },
  {
    'country': 'Guyana',
    'population': 786552,
    'density': 4,
    'land Area': 196850
  },
  {
    'country': 'Haiti',
    'population': 11402528,
    'density': 14,
    'land Area': 275604
  },
  {'country': 'Holy See', 'population': 8010, 'density': 0, 'land Area': 2003},
  {
    'country': 'Honduras',
    'population': 9904607,
    'density': 89,
    'land Area': 111890
  },
  {
    'country': 'Hungary',
    'population': 9660351,
    'density': 07,
    'land Area': 905301
  },
  {
    'country': 'Iceland',
    'population': 341243,
    'density': 03,
    'land Area': 10025
  },
  {
    'country': 'India',
    'population': 1380004385,
    'density': 64,
    'land Area': 29731904
  },
  {
    'country': 'Indonesia',
    'population': 273523615,
    'density': 51,
    'land Area': 18115701
  },
  {
    'country': 'Iran',
    'population': 83992949,
    'density': 52,
    'land Area': 1628550
  },
  {
    'country': 'Iraq',
    'population': 40222493,
    'density': 93,
    'land Area': 434320
  },
  {
    'country': 'Ireland',
    'population': 4937786,
    'density': 72,
    'land Area': 68890
  },
  {
    'country': 'Israel',
    'population': 8655535,
    'density': 00,
    'land Area': 216404
  },
  {
    'country': 'Italy',
    'population': 60461826,
    'density': 06,
    'land Area': 2941402
  },
  {
    'country': 'Jamaica',
    'population': 2961167,
    'density': 73,
    'land Area': 108302
  },
  {
    'country': 'Japan',
    'population': 126476461,
    'density': 47,
    'land Area': 3645553
  },
  {
    'country': 'Jordan',
    'population': 10203134,
    'density': 15,
    'land Area': 887801
  },
  {
    'country': 'Kazakhstan',
    'population': 18776707,
    'density': 07,
    'land Area': 269970
  },
  {
    'country': 'Kenya',
    'population': 53771296,
    'density': 94,
    'land Area': 569140
  },
  {
    'country': 'Kiribati',
    'population': 119449,
    'density': 47,
    'land Area': 8101
  },
  {
    'country': 'Kuwait',
    'population': 4270571,
    'density': 240,
    'land Area': 17820
  },
  {
    'country': 'Kyrgyzstan',
    'population': 6524195,
    'density': 34,
    'land Area': 191800
  },
  {
    'country': 'Laos',
    'population': 7275560,
    'density': 32,
    'land Area': 230800
  },
  {
    'country': 'Latvia',
    'population': 1886198,
    'density': 30,
    'land Area': 62200
  },
  {
    'country': 'Lebanon',
    'population': 6825445,
    'density': 667,
    'land Area': 10230
  },
  {
    'country': 'Lesotho',
    'population': 2142249,
    'density': 71,
    'land Area': 30360
  },
  {
    'country': 'Liberia',
    'population': 5057681,
    'density': 53,
    'land Area': 96320
  },
  {
    'country': 'Libya',
    'population': 6871292,
    'density': 4,
    'land Area': 1759540
  },
  {
    'country': 'Liechtenstein',
    'population': 38128,
    'density': 238,
    'land Area': 160
  },
  {
    'country': 'Lithuania',
    'population': 2722289,
    'density': 43,
    'land Area': 62674
  },
  {
    'country': 'Luxembourg',
    'population': 625978,
    'density': 242,
    'land Area': 2590
  },
  {
    'country': 'Madagascar',
    'population': 27691018,
    'density': 48,
    'land Area': 581795
  },
  {
    'country': 'Malawi',
    'population': 19129952,
    'density': 203,
    'land Area': 94280
  },
  {
    'country': 'Malaysia',
    'population': 32365999,
    'density': 99,
    'land Area': 328550
  },
  {
    'country': 'Maldives',
    'population': 54054,
    'density': 300,
    'land Area': 1802
  },
  {
    'country': 'Mali',
    'population': 20250833,
    'density': 17,
    'land Area': 1220190
  },
  {'country': 'Malta', 'population': 44154, 'density': 320, 'land Area': 1380},
  {
    'country': 'Marshall Islands	',
    'population': 59190,
    'density': 329,
    'land Area': 180
  },
  {
    'country': 'Mauritania',
    'population': 4649658,
    'density': 5,
    'land Area': 1030700
  },
  {
    'country': 'Mauritius',
    'population': 1271768,
    'density': 626,
    'land Area': 2030
  },
  {
    'country': 'Mexico',
    'population': 128932753,
    'density': 66,
    'land Area': 1943950
  },
  {
    'country': 'Micronesia',
    'population': 548914,
    'density': 784,
    'land Area': 700
  },
  {
    'country': 'Moldova',
    'population': 4033963,
    'density': 123,
    'land Area': 32850
  },
  {'country': 'Monaco', 'population': 392421, 'density': 26337, 'land Area': 1},
  {
    'country': 'Mongolia',
    'population': 3278290,
    'density': 2,
    'land Area': 1553560
  },
  {
    'country': 'Montenegro',
    'population': 628066,
    'density': 47,
    'land Area': 13450
  },
  {
    'country': 'Morocco',
    'population': 36910560,
    'density': 83,
    'land Area': 446300
  },
  {
    'country': 'Mozambique',
    'population': 31255435,
    'density': 40,
    'land Area': 786380
  },
  {
    'country': 'Myanmar (formerly Burma)',
    'population': 54409800,
    'density': 83,
    'land Area': 653290
  },
  {
    'country': 'Namibia',
    'population': 2540905,
    'density': 3,
    'land Area': 823290
  },
  {'country': 'Nauru', 'population': 10824, 'density': 541, 'land Area': 20},
  {
    'country': 'Nepal',
    'population': 29136808,
    'density': 203,
    'land Area': 143350
  },
  {
    'country': 'Netherlands',
    'population': 17134872,
    'density': 508,
    'land Area': 33720
  },
  {
    'country': 'New Zealand',
    'population': 4822233,
    'density': 18,
    'land Area': 263310
  },
  {
    'country': 'Nicaragua',
    'population': 6624554,
    'density': 55,
    'land Area': 120340
  },
  {
    'country': 'Niger',
    'population': 24206644,
    'density': 19,
    'land Area': 1266700
  },
  {
    'country': 'Nigeria',
    'population': 206139589,
    'density': 26,
    'land Area': 9107702
  },
  {
    'country': 'North Korea	',
    'population': 25778816,
    'density': 14,
    'land Area': 1204102
  },
  {
    'country': 'North Macedonia',
    'population': 2083374,
    'density': 83,
    'land Area': 25220
  },
  {
    'country': 'Norway',
    'population': 5421241,
    'density': 15,
    'land Area': 365268
  },
  {
    'country': 'Oman',
    'population': 5106626,
    'density': 16,
    'land Area': 309500
  },
  {
    'country': 'Pakistan',
    'population': 220892340,
    'density': 287,
    'land Area': 770880
  },
  {'country': 'Palau', 'population': 18094, 'density': 39, 'land Area': 460},
  {
    'country': 'Palestine State',
    'population': 5101414,
    'density': 847,
    'land Area': 6020
  },
  {
    'country': 'Panama',
    'population': 4314767,
    'density': 58,
    'land Area': 74340
  },
  {
    'country': 'Papua New Guinea',
    'population': 8947024,
    'density': 20,
    'land Area': 452860
  },
  {
    'country': 'Paraguay',
    'population': 7132538,
    'density': 18,
    'land Area': 397300
  },
  {
    'country': 'Peru',
    'population': 32971854,
    'density': 26,
    'land Area': 1280000
  },
  {
    'country': 'Philippines',
    'population': 109581078,
    'density': 368,
    'land Area': 298170
  },
  {
    'country': 'Poland',
    'population': 37846611,
    'density': 124,
    'land Area': 306230
  },
  {
    'country': 'Portugal',
    'population': 10196709,
    'density': 111,
    'land Area': 91590
  },
  {
    'country': 'Qatar',
    'population': 2881053,
    'density': 248,
    'land Area': 11610
  },
  {
    'country': 'Romania',
    'population': 19237691,
    'density': 84,
    'land Area': 230170
  },
  {
    'country': 'Russia',
    'population': 145934462,
    'density': 9,
    'land Area': 1637680
  },
  {
    'country': 'Rwanda',
    'population': 12952218,
    'density': 525,
    'land Area': 24670
  },
  {
    'country': 'Saint Kitts and Nevis',
    'population': 53199,
    'density': 205,
    'land Area': 260
  },
  {
    'country': 'Saint Lucia',
    'population': 183627,
    'density': 301,
    'land Area': 610
  },
  {
    'country': 'Saint Vincent and the Grenadines',
    'population': 110940,
    'density': 284,
    'land Area': 390
  },
  {'country': 'Samoa', 'population': 198414, 'density': 70, 'land Area': 2830},
  {
    'country': 'San Marino',
    'population': 33931,
    'density': 566,
    'land Area': 60
  },
  {
    'country': 'Sao Tome and Principe',
    'population': 219159,
    'density': 228,
    'land Area': 960
  },
  {
    'country': 'Saudi Arabia	',
    'population': 34813871,
    'density': 16,
    'land Area': 2149690
  },
  {
    'country': 'Senegal',
    'population': 16743927,
    'density': 87,
    'land Area': 192530
  },
  {
    'country': 'Serbia',
    'population': 8737371,
    'density': 100,
    'land Area': 87460
  },
  {
    'country': 'Seychelles',
    'population': 98347,
    'density': 214,
    'land Area': 460
  },
  {
    'country': 'Sierra Leone',
    'population': 7976983,
    'density': 111,
    'land Area': 72180
  },
  {
    'country': 'Singapore',
    'population': 5850342,
    'density': 8358,
    'land Area': 700
  },
  {
    'country': 'Slovakia',
    'population': 5459642,
    'density': 114,
    'land Area': 48088
  },
  {
    'country': 'Slovenia',
    'population': 2078938,
    'density': 103,
    'land Area': 20140
  },
  {
    'country': 'Solomon Islands',
    'population': 686884,
    'density': 25,
    'land Area': 27990
  },
  {
    'country': 'Somalia',
    'population': 15893222,
    'density': 25,
    'land Area': 627340
  },
  {
    'country': 'South Africa',
    'population': 59308690,
    'density': 49,
    'land Area': 1213090
  },
  {
    'country': 'South Korea',
    'population': 51269185,
    'density': 527,
    'land Area': 97230
  },
  {
    'country': 'South Islands',
    'population': 11193725,
    'density': 18,
    'land Area': 610952
  },
  {
    'country': 'Spain',
    'population': 46754778,
    'density': 94,
    'land Area': 498800
  },
  {
    'country': 'Sri Lanks',
    'population': 21413249,
    'density': 341,
    'land Area': 62710
  },
  {
    'country': 'Sudan',
    'population': 43849260,
    'density': 25,
    'land Area': 1765048
  },
  {
    'country': 'Suriname',
    'population': 586632,
    'density': 04,
    'land Area': 15600
  },
  {
    'country': 'Sweden',
    'population': 10099265,
    'density': 25,
    'land Area': 410340
  },
  {
    'country': 'Switzerland',
    'population': 8654622,
    'density': 219,
    'land Area': 39516
  },
  {
    'country': 'Syria',
    'population': 17500658,
    'density': 95,
    'land Area': 183630
  },
  {
    'country': 'Tajikistan',
    'population': 9537645,
    'density': 68,
    'land Area': 139960
  },
  {
    'country': 'Tanzania',
    'population': 59734218,
    'density': 67,
    'land Area': 885800
  },
  {
    'country': 'Thailand',
    'population': 69799978,
    'density': 137,
    'land Area': 510890
  },
  {
    'country': 'Timor Leste',
    'population': 1318445,
    'density': 89,
    'land Area': 14870
  },
  {
    'country': 'Togo',
    'population': 8278724,
    'density': 52,
    'land Area': 543901
  },
  {'country': 'Tonga', 'population': 105695, 'density': 247, 'land Area': 720},
  {
    'country': 'Trinidad and Tobago',
    'population': 1399488,
    'density': 273,
    'land Area': 5130
  },
  {
    'country': 'Tunisia',
    'population': 11818619,
    'density': 76,
    'land Area': 155360
  },
  {
    'country': 'Turkey',
    'population': 84339067,
    'density': 10,
    'land Area': 7696301
  },
  {
    'country': 'Turkmenistan',
    'population': 6031200,
    'density': 13,
    'land Area': 469930
  },
  {'country': 'Tuvalu', 'population': 11792, 'density': 393, 'land Area': 30},
  {
    'country': 'Uganda',
    'population': 45741007,
    'density': 229,
    'land Area': 199810
  },
  {
    'country': 'Ukraine',
    'population': 43733762,
    'density': 75,
    'land Area': 579320
  },
  {
    'country': 'United Arab Emirates',
    'population': 9890402,
    'density': 18,
    'land Area': 836001
  },
  {
    'country': 'United Kingdom',
    'population': 67886011,
    'density': 281,
    'land Area': 241930
  },
  {
    'country': 'United States of America',
    'population': 331002651,
    'density': 36,
    'land Area': 9147420
  },
  {
    'country': 'Uruguay',
    'population': 3473730,
    'density': 20,
    'land Area': 175020
  },
  {
    'country': 'Uzbekistan',
    'population': 33469203,
    'density': 79,
    'land Area': 425400
  },
  {
    'country': 'Vanuatu',
    'population': 307145,
    'density': 25,
    'land Area': 12190
  },
  {
    'country': 'Venezuela',
    'population': 28435940,
    'density': 32,
    'land Area': 882050
  },
  {
    'country': 'Vietnam',
    'population': 97338579,
    'density': 314,
    'land Area': 310070
  },
  {
    'country': 'Yemen',
    'population': 29825964,
    'density': 56,
    'land Area': 527970
  },
  {
    'country': 'Zambia',
    'population': 18383955,
    'density': 25,
    'land Area': 743390
  },
  {
    'country': 'Zimbabwe',
    'population': 4862924,
    'density': 38685038,
    'land Area': 27400
  }
];
