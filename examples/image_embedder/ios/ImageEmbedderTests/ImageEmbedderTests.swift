// Copyright 2024 The MediaPipe Authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import XCTest
@testable import ImageEmbedder
import MediaPipeTasksVision

final class ImageEmbedderTests: XCTestCase {

  static let mobilenetV3Small = Model.mobilenet_v3_small
  static let mobilenetV3Large = Model.mobilenet_v3_large

  static let testImage = UIImage(
    named: "cup.png",
    in:Bundle(for: ImageEmbedderTests.self),
    compatibleWith: nil)!

  static let mobilenetV3LargeEmbeddingResult = Embedding(
    floatEmbedding: [0.1771821, -0.2615722, 1.021964, 0.5832246, -0.3481483, -0.243715, 1.688498, 0.03744224, -0.374951, -0, -0, -0.192925, 0.0141324, 0.3349236, -0.2015125, -0.2505761, 0.00394722, -0.3614892, -0.3694473, -0, -0.3216593, -0.3724969, -0.09182895, 0.2113194, -0.3434092, -0.3588775, -0.2326632, -0.2972592, -0.1887504, -0.1667725, -0.2683814, -0.0432267, -0.2394929, -0.2832833, -0.124117, 0.6351482, -0.2607899, -0, -0.3584262, -0.3735827, 0.1533502, -0.1278086, -0.115985, -0, -0.3749155, -0.2685203, -0.227386, 0.5234877, -0.3342691, -0.2178902, -0.3379715, 0.1713437, 0.002120784, -0.373606, -0.3285973, 0.0315645, -0.3748821, -0.3377343, -0.1849071, 0.1159173, -0.1755215, -0.2204666, -0.3633643, -0.1343663, -0.05215303, -0.3745641, -0.368647, -0, -0.02290685, 0.6501773, 0.7279732, -0.1362313, -0.3329073, 0.3572079, 0.3260967, -0.3749442, 0.1044447, -0.32854, -0.3459938, -0.2665198, -0.2175837, 0.1598212, -0.296718, -0.2211784, -0.216153, -0.1451274, -0, -0.2236882, -0.1506209, -0.3127375, -0.06521522, -0.04367394, -0.3698419, 0.03306494, -0.373504, 0.5642492, 0.1264073, 0.07822149, -0, -0.2919038, -0.00814274, -0.3685127, -0.1551933, -0.2532596, -0.1258338, -0, -0.3614437, -0, -0.02121209, 1.225557, -0.2030448, 0.5033061, -0.347012, -0.09182776, -0.1154961, -0, 0.02746265, -0.2963119, -0.3544547, -0.3547986, -0.2008182, 0.05561563, 0.2814788, -0.3738487, -0.3125618, 0.1644801, -0.3737641, -0.05496508, -0.2530393, -0.08616728, 0.03377248, -0.01092724, 0.7408726, -0.2823764, 0.07136197, -0.311706, 1.226024, 0.03106068, 0.04764313, -0.3221054, -0.3191057, -0.3644222, -0.1443816, -0.2968887, -0.06070308, -0.1848945, -0.07338449, 0.5786849, -0.3747983, -0.2569626, -0.3460934, -0.3481086, -0.1941595, -0.1439931, -0.1259989, -0, -0.3046422, -0.3603576, -0.3641004, -0.3678599, -0, -0.3412968, -0.09412, -0.3628311, 0.1749903, -0.3264355, -0.3744238, -0.186501, -0.2056466, 0.2823983, -0.3361698, 0.4410192, -0, 0.7488978, -0.3094368, -0.2219307, -0.3440177, 1.040212, -0.2183211, -0.2864608, -0.06004867, -0.3318924, 0.0443513, -0.3218355, -0.375, -0.149691, -0.2833266, 0.07461212, -0.3725373, -0, -0.2905718, -0.3131845, -0.2651128, -0.3381639, 0.2483743, -0.2235728, -0.1732979, -0.1851754, -0.2911977, -0.2976958, -0.3745564, -0.3615398, -0.3680346, -0.374927, -0.09620102, -0.01959499, -0.1886544, 0.05813271, -0.3443816, 0.1977843, -0.2851133, -0.2027636, 0.1994732, -0.2520539, -0.2429004, 0.7857689, 0.2344386, -0.2646051, -0.3664253, -0.1845863, -0.2826632, 1.698361, 0.1632296, -0, 0.8038599, 0.3213516, -0.3589706, 0.0590758, -0.1501224, 0.366254, 1.155288, -0.3617598, -0.3152625, 0.86857, -0.3689212, -0.2468968, -0.3449057, -0.1141768, -0.3380402, 0.7777084, -0, -0.1274137, 1.128157, 0.008442604, -0.2624731, -0.05949851, -0.3749998, -0.01176889, -0.3623972, -0, -0.04536763, -0.3747242, -0.374372, 0.1637573, -0.3572858, 0.478545, 0.3826588, 0.1022137, -0.3730412, 0.1676681, -0.3310981, -0.09891028, -0.2693955, -0.3727428, -0.3738193, -0.2106077, -0.3745086, -0.1088568, -0.3122926, -0, -0.3387824, -0.1211778, 0.1959919, 0.1402527, -0.3064502, -0.2281047, -0.2484471, 0.5652984, 0.05382401, 0.195462, -0, 0.4438601, -0.06336001, -0.3499196, -0, 0.7593758, -0.2104311, -0, 0.1993267, -0.2406627, -0.3697542, -0, 0.3396268, -0.3662575, -0.3374017, 0.1509179, -0.2572113, -0.3634008, -0.3367524, 0.6116918, -0.2062868, -0.3121924, -0.3749965, -0.3252816, 0.2173391, 0.1180397, 0.2200573, -0.2404996, -0.01635636, -0.3420126, 0.7226454, -0.3637925, -0, -0, 0.3905489, -0.2474184, -0, 0.3853808, -0, -0.1761756, 0.1909937, -0, 0.405787, -0.07984672, -0, -0.2702482, -0, 0.7318738, -0.358777, -0.313022, -0.08755147, -0.1183317, 0.1060004, -0.2582166, 0.1622692, 0.1511653, -0.2099495, 0.3495568, 0.6604627, -0.3687547, -0.1061639, -0.3416325, 0.1088352, 0.2091987, -0.2615258, 0.1060028, -0.2038145, -0.1114416, -0.3071987, 0.2605777, 0.526002, -0.2236932, -0, -0.1035892, -0.3721069, -0.229731, -0.2721512, 1.33556, -0.3749882, -0.1615598, -0.3749912, -0.286391, 0.1407322, -0.1365505, 0.6186411, -0.1423676, -0.3648629, 0.3922211, 0.0168965, -0.3207674, -0.3280778, 0.3918343, 0.7748098, -0.149135, -0.3605169, -0.3661901, -0.2159752, 0.04428623, 0.3300111, -0.3587778, -0.3549647, -0.2774415, -0.265456, -0.02730884, -0.107548, -0.3090961, -0.1754741, 0.02716207, -0.3749154, -0.3494004, -0.03050245, -0.3732456, 0.2926728, -0.3723471, -0.3743757, -0.3190491, 0.4625386, 0.02081414, -0.3438879, -0.2123512, -0.3749346, -0.127714, 0.1681432, -0.3311931, -0.21463, -0.05196984, 0.03262471, -0.2705105, 0.3032722, -0.3484951, -0.338478, 0.1473568, -0.225263, -0.2219818, -0.004428586, -0.2474577, -0.3731936, -0.3599453, -0.3589323, -0.3031963, 0.1158482, -0.1744215, -0.3001826, -0.07349735, -0, -0.3211535, -0.2579798, 0.683402, -0.3669969, 0.4410712, -0.1560911, -0.2190146, -0, -0.07687758, -0.319942, 0.3111303, -0.3140043, -0.2916614, -0.152308, 0.4114462, -0.1990489, -0.2276727, -0.1705916, -0.133822, 0.3336975, -0.208448, -0.3635183, 0.008490038, -0.138091, -0.0673945, -0.304353, -0.0607488, -0, 0.206564, -0.313307, -0.1898889, -0.3476419, -0.3631209, -0.3448375, -0.3168087, 0.0205391, -0.3615776, -0.0350392, -0.3589358, -0.3597405, 0.2418755, -0.08712804, 0.0963866, -0.3050674, -0.3531883, -0.2826618, 0.04339774, -0.3736434, -0.1141984, -0.2229103, -0.1617785, -0.3108626, -0.3566107, -0.1165154, -0.3440949, -0.2770741, -0.3456178, -0.372432, -0.06986843, 0.4266568, -0.2275852, -0.3705208, -0.2932179, -0.2494871, -0, -0.1793729, -0.0846353, 0.05244673, -0.1239475, -0.373331, 0.06779147, -0, -0, 0.4568441, -0.2762836, -0.190761, 0.6348069, -0.3405514, 0.2034469, -0.3749796, 0.3915645, -0.3706673, 0.05074523, -0.3410985, 0.2597475, -0.3720697, -0.2279756, -0.3095503, -0.3749515, 0.03093587, -0.3508973, 0.1423869, 0.2787267, -0.09226494, -0.2395172, -0.2762701, -0.3221269, -0.3249163, -0.242429, -0.2226221, -0.3423024, -0.3406106, -0, -0.3475024, -0.2323981, -0.2187477, -0.114603, -0.2052685, -0.167092, -0, -0.2687782, -0.3446109, 0.5479767, -0.3724835, -0.2772097, 1.004548, -0.055006, -0.3397666, -0.3705744, -0.3476999, -0.3477268, -0.290959, -0.09002708, -0.3507079, -0.1182393, 1.156979, 1.790713, -0.3746504, -0.2949515, 0.03757145, -0.3406861, -0.2572004, -0.2855464, 0.001525132, -0.2546431, -0.3742446, -0.07348876, -0.3690112, -0.2862856, 0.4598465, 0.9071068, -0.3699496, 0.744492, -0.1395907, -0.361737, -0.05588172, -0, -0, 0.2193112, 0.05182822, -0.3690962, 0.01518786, 0.06747843, -0, 0.6337465, -0, -0.136834, -0.227604, -0, -0.3560538, -0.3558256, -0, 0.6744446, -0.1600083, -0, -0.114276, -0.2664377, 0.03911136, -0.2996777, -0.355963, -0.3482361, -0.09805995, -0.06371955, -0.2984251, -0.215437, 0.2997906, -0.3446585, -0.3373382, -0.3627444, -0, 0.08846518, -0.3480375, -0, -0.3160231, 0.3111213, 0.2909843, -0, 0.6355608, -0.3732347, -0.1988284, -0.2988754, -0.374985, -0.2162877, -0.3640446, -0, -0.2052768, -0.3487587, -0.2563454, -0.03565627, -0.3643316, -0.3671568, -0.3197445, -0, 0.1874138, -0.3055733, -0.2243044, -0.3745723, 0.0922488, -0.213644, -0.3414789, -0.05987496, 0.05908585, -0.06512962, -0.3132441, -0.2647522, -0.2990091, -0, 0.3654691, -0.2863534, -0.3336632, -0.03491987, -0.06270628, -0.08598273, 0.4918663, -0.3742375, -0.3015478, -0.2123712, -0.2357588, -0.3749846, -0.05450997, -0.3534668, -0, 0.1002203, -0.360444, -0.3640979, -0.1525283, 1.120441, -0.3453108, 0.1120682, -0.3736517, -0.1436102, -0.2405764, -0, -0.3091601, -0.3665375, -0, -0.3672004, -0.3746645, -0.1865451, -0.2769466, 0.1383056, -0.07213892, 1.574348, -0.2210555, -0.1976939, -0.3523337, 0.380381, -0.2553515, -0.2995911, -0.1805742, -0.3602341, -0.03154104, 0.08347291, -0, 1.426904, -0.3223135, 0.04566037, 0.3978151, -0.1030867, -0.190391, -0.3146752, -0.3448403, -0.36685, -0.2031896, -0.1279178, -0, 0.3983719, -0.2649041, -0.3368846, -0.2574872, -0.3028375, -0.3308037, -0.3091589, -0.3465255, 0.4544664, -0.2803782, -0.3711477, 0.1220663, 0.3933079, -0.1627876, -0.07726428, -0, -0.2480893, 0.332567, -0.3122905, 0.7484549, 0.2264706, -0.3672892, 0.5488466, -0, -0.008861021, 0.05296578, -0.005843465, -0.3150222, -0.3693728, 1.266511, -0.35162, -0, -0.3412029, 0.4507939, -0.1970753, -0.3370569, 0.2106129, -0.1302404, -0.3647353, -0.1664556, -0.3598319, 0.1590028, -0.3362543, -0.3686781, 0.5725662, -0.330698, -0.3393988, -0.001932569, -0.1175278, 0.364499, -0.3578593, -0.1778029, -0.3737856, 0.1881699, 0.3501817, -0, -0.191878, -0.02356827, -0.2336202, -0.3395584, -0.3657948, -0.3553086, -0.04763591, -0.05398793, 0.390377, -0.2857146, -0.2794086, -0.001792578, 0.6239352, -0.3531145, -0.3749532, -0, -0.2040091, -0.1358239, -0.3168262, -0.3462954, -0.2280043, -0.202304, -0.2458689, -0.3730437, 0.1056225, -0.1245073, 0.1551299, -0.02603145, -0, -0.3095526, -0.07105588, 0.03158827, 0.310157, -0, 1.359236, 0.08868944, -0.1752211, -0.3183139, -0.1086751, -0.1431255, -0.2533887, -0.1977501, -0.3383284, -0.2145779, -0.1104689, -0.1437949, -0.3006942, 0.01606929, -0.302179, -0.37456, -0.3513777, 0.1857924, -0.3461115, -0.2053671, -0.319239, -0.3702084, -0.01724331, 0.3220465, -0.009176832, -0.3627917, 0.2448174, 0.8714354, -0.3607332, -0.04059506, -0.2020154, -0.03259621, -0, -0.2659471, 1.097766, -0.3704739, -0.3320847, -0.3294522, -0.1678097, -0.3430077, 0.5915843, -0.2728961, -0.3396919, -0.2177189, -0.1371601, -0.316976, -0.07576724, -0.07153516, -0.3321195, -0.3386625, -0, -0.192795, 0.09362874, -0.3479144, 0.1918827, 0.5336738, -0.2603075, -0, -0.3127766, 0.04383311, -0.01312306, -0.2958135, -0.3459086, -0.2695279, -0.1474816, 1.209577, 0.1448806, -0.2793625, -0.2591876, -0.3610813, 1.235581, -0.2993123, -0.09415746, 1.030256, -0.3277134, -0.3633898, 0.3107339, -0.345229, -0.2662899, -0, -0.2171943, 0.2301095, 0.3965333, -0.2093571, -0.2925849, -0.1107551, -0.1496407, 0.09879942, -0.0399056, -0.3514419, -0.3347873, -0.1964226, 0.1439465, 0.4494932, -0.3493443, -0.3538815, -0.04595319, 0.1048508, -0.184297, -0, -0.2834002, -0.04080225, -0.3434506, -0.3704189, 0.1440759, 0.3287909, -0.1847514, 0.1018855, -0.3552407, -0, -0.3747203, 0.08421686, -0.3528961, -0.0952456, 0.224888, -0.1936704, 0.5786131, -0.3020649, 0.05130676, -0.07977492, -0.3568655, -0.3338566, -0.02803732, -0.2609278, 0.4606436, -0.2602865, -0.2702422, -0.3747558, -0.3617878, -0.08993294, -0.3730058, -0.2878692, 0.4902823, -0, -0.3660853, -0.3731049, -0, -0.2939841, -0.002365509, -0.3700664, -0, -0.3470485, -0.1252535, -0.1931605, -0, 0.1872283, -0.3622678, 0.5714484, -0.2431819, -0.2795713, 1.235734, -0.1260942, 0.02545646, -0.2787624, -0.01426638, 0.03883911, 0.3879676, -0.22632, -0.3630986, -0.09334317, -0.3559899, -0.2614676, -0.374987, -0.1686233, -0.3579384, -0.3747108, -0.3669808, -0.1564925, -0.2739655, -0.153069, -0.1177111, -0.06804484, -0.3104401, -0.001678306, -0, -0.05638143, -0.3334664, -0.3243383, -0.359809, 0.3729668, -0.3434264, 0.6352013, -0.3688181, -0.1616706, -0, -0.3747188, 0.1398133, -0.3145175, -0.3402499, -0.3360384, 0.7465756, -0.237897, -0.01981326, -0.2771441, 0.6242956, -0.06723692, -0, -0.3620543, -0.1378925, -0.349355, -0.3593495, -0.01534749, 1.117592, -0.2576746, 0.2011379, -0.2474896, -0.3476787, -0.3668164, -0.3563662, -0, 0.3807591, -0.3743012, 0.4486629, -0.3725949, -0.1170393, -0.2360339, -0.3683343, -0, 0.6570144, -0.2799542, -0.3191506, -0, -0.3728918, 0.6733684, -0.374997, -0.3728585, -0.2286698, 0.1444008, -0.3542672, -0.2213191, -0.1262539, -0.3706303, -0.2725436, -0, 0.1041803, -0.3733646, 0.1161598, -0, -0.3748518, 0.129162, -0.1551029, -0.2981476, -0.2882137, -0.2018726, 0.2292846, -0.1739226, -0.0746318, -0.3636181, -0.2328494, -0.3312602, 0.38629, -0.3080069, -0.2486552, 0.2318548, -0.09596597, -0.2577397, -0.3738159, 0.9627898, -0.3196983, 0.4779236, -0.3626941, -0.05139934, -0.3514624, -0.3503493, 0.06291778, -0.235897, -0.1174588, -0.2293286, -0.3230399, -0.3726048, -0.3694525, 0.1435371, -0.3735777, 0.2972115, -0.3635324, 0.2652813, -0.2953575, 0.1114851, 0.009920248, -0.34841, -0.1906212, -0.3679708, -0, -0.2016221, 1.037354, 0.04057256, -0.01287792, -0.3723632, -0.2259105, -0.3742136, -0.3709026, 0.2268837, -0.3069392, -0.288794, -0, -0.3250567, -0.3614316, -0.1227461, 0.01886155, -0.3319447, -0.2729401, -0.3089721, -0, 0.4696247, 0.01895954, 0.7062968, -0.3140671, -0.2615784, -0.3521295, 0.424136, 0.3785712, 0.1115819, -0.1079552, 0.2011706, 0.1423589, 0.1006253, -0.3739482, -0, -0.3548877, -0.2400514, -0.03078573, -0.3189733, 0.7905115, -0, -0.07705084, -0.300296, -0.2658565, -0.03504828, -0.300825, 0.1147917, -0.294697, 0.2861279, -0.3493911, -0.335333, -0.03748487, -0.3074979, 0.2036278, 0.6934458, -0.2943492, 0.6016253, -0.3742879, -0.1249459, -0.3633761, -0.3400541, -0.346799, 0.3645376, -0, 0.451977, -0.3640239, -0.19806, -0.1551241, 0.1095703, -0.3537999, 0.3155393, 0.2148143, -0.1974045, -0, -0.3201911, -0.3685232, 0.1635108, -0.3718104, -0.2851643, -0.328927, -0.3674127, 0.708017, -0, -0.2134395, -0.3402787, -0, -0.333206, -0.09088083, -0.1661264, 0.5209497, -0.1865595, -0.3736407, -0.3084735, -0.1218658, -0.2858651, 0.4072461, 0.5072689, -0.2808653, -0.2182529, -0, -0, -0.3155991, -0.3690922, 0.3558264, -0.06953907, -0.3158163, -0.1814744, 0.1113377, -0.3562287, 0.1907807, 0.2684067, -0.1739062, -0, -0.3718078, -0.009056501, -0.3235313, -0.2259558, -0.3745246, -0.06648077, -0.2939773, -0.1435905, -0.3070939, -0.2606401, -0.3605557, -0.1867392, 0.5429066, -0.2845255, -0, -0.1922432, -0.3591463, -0.01451567, -0.07630444, 0.0382318, -0.3509112, 0.1129501, -0.1816659, -0.3720731, -0.05866835, -0.3747551, -0.2992781, -0.3385144, -0.3361177, -0.1838609, -0.3397864, 0.3590373, 0.30981, -0.3046284, -0.3749435, 0.5421084, 0.2669564, -0.1164252, 0.07627109, -0.2671658, -0.3499963, 1.038012, -0.190763, -0, 0.3664549, 0.8070063, -0, -0, -0.2275999, 0.1241547, 0.2072878, -0, -0, -0.3579159, -0.3703387, 0.004053012, -0.2216869, -0.2109378, -0.3001825, -0.3747666, -0.2895327, -0.3749823, -0.1048257, -0.363244, -0.3235767, -0, -0.3709676, -0.09850356, -0.3253612, -0.355348, 0.4193647, -0.1998512, -0.2761558, -0, -0.3255284, 0.8985323, -0.3614399, 0.06394732, -0.2354734, -0.3204154, -0.3658027, 0.4311696, -0.3270133, -0, -0.3739506, -0.360185, -0.03901071, 0.09303484, -0.3551434, -0, -0.2986239, -0.2861258, -0.3407184
  ], quantizedEmbedding: nil, head: 0, headName: nil)
  static let mobilenetV3SmallEmbeddingResult = Embedding(
    floatEmbedding: [0.05448581, -0.3244404, -0.3043502, -0.3366923, -0, -0, -0.2367669, -0.1644832, -0.3749852, 0.3607682, -0.2907408, 0.5496427, -0, -0.1676985, -0.2727915, -0.08962502, -0.2264084, -0, -0.3680649, 0.4732879, -0.1763778, -0, -0.1219935, -0.2689551, 0.02491409, -0, 0.04380257, 1.343247, -0.3081102, -0.3370067, -0.2480415, -0, -0.1483878, 1.114445, -0.3609488, -0.0228415, 2.536394, -0.3004802, -0.2645711, -0.159237, -0, -0.3229369, -0.05413826, -0, -0.0275792, -0, 0.004061791, -0, 1.137461, 1.122758, -0.1655777, -0.1022687, -0, -0, -0.3746581, 0.06512546, -0.2047088, -0.3100575, -0.1083205, -0.3583694, -0.2360163, -0.3749538, -0, -0.09239903, -0, 1.196555, -0.1221779, -0.3508539, 0.09951002, 0.1836186, -0.2239749, -0.2894828, -0.3297167, -0, -0.3637682, -0, 2.111591, -0.003278331, -0.2665333, -0.257977, -0.2034338, -0, -0.1273504, -0.191774, -0.3482626, -0.2802522, -0.3673781, -0, -0.07944936, -0.2305422, -0, -0.04504588, -0.3593578, -0.3745529, -0.3739844, -0.3624405, 0.9162812, -0.3490164, -0.2899712, -0, 0.1204368, -0.115787, 0.6489798, -0.3015562, -0.07580482, 0.8365407, -0.04869396, -0.3733817, 0.6273727, 0.09512491, -0.1071331, -0.2648447, -0, 0.2000095, -0.3197695, 0.5049177, -0.08026956, -0.3669921, -0.06307179, -0.05853948, -0.3542451, -0.3234702, -0, 0.8315268, -0.3060373, -0, -0.07477725, 0.6639974, -0.1874438, -0.3499152, -0, -0.1457407, -0.201144, -0, 0.1846712, -0, 0.1602005, -0.1837446, 0.6736025, -0.2960624, -0.3733393, -0, -0.2138599, -0.2397099, 0.8241, -0.3504722, 0.2745017, -0.2426219, -0.3748659, -0.3715193, 1.266417, -0.2836264, -0.2736228, -0.3648181, -0, -0.09038991, 0.6824815, -0.303962, 0.3764904, -0.3742409, -0.2970468, -0.3326435, -0.07471293, 1.201565, -0, 1.057377, -0.3441869, -0.3323678, -0.2994056, -0.3748047, -0.2549979, -0.3598483, -0.2111569, 0.4409802, -0.3248002, -0.1525559, -0.3004187, -0.363054, 0.7596917, -0.1634748, -0.2727817, -0, 1.423652, 0.4744977, -0, 0.6722992, 0.8216945, 0.9619699, -0.3660313, -0, -0.2871893, -0.1952694, -0, -0.3734393, 0.04147727, -0.08645216, -0.03037392, -0.1093138, -0.3326813, 0.8209823, -0.345204, -0.3724883, -0.07115584, 1.106326, -0.3684948, -0, -0.3710838, -0.05910001, -0.302746, -0.2551517, -0.2564718, -0.3694955, -0.3639156, 0.1212275, -0.1808082, -0, -0, -0, -0.3488591, -0.3707101, -0, -0.3590428, -0.0334462, -0.359227, -0.359669, -0.30051, -0.3510217, -0.288724, -0.357509, -0.29362, 0.2493301, 0.5894448, -0.3459483, -0.2729233, 0.6189629, -0, -0, -0, 1.303727, -0.03470469, -0.348913, -0.2899581, 0.8461936, 0.3377329, -0.08163072, -0.2429516, -0.1921301, 0.3533692, -0, -0.3492589, -0.2768419, 0.1786732, -0.347393, -0.3587836, -0, -0.2161085, -0.3733915, -0.3689697, -0.3691428, 0.03560732, -0.3589211, -0.195802, 0.594131, -0.2589815, -0.3359443, -0.162009, -0.2994639, 0.2109668, 0.1219819, -0, -0.3225338, 1.606203, -0.3370106, -0.3461422, -0.3742729, 1.005008, -0.3727511, -0, -0, 0.8027321, 0.1555614, -0, 0.8552442, -0.3129975, -0.02531721, -0.05550992, -0.3605538, -0.3097788, 0.5807553, -0.3548046, 0.1541957, 0.5011132, 0.2518919, 0.05852035, -0.3466899, -0.2007227, 0.1092633, -0.2613838, -0.3468725, 0.6093513, -0.359055, -0.343593, -0, -0, -0.3109303, -0.04735306, 0.1009458, -0.3434523, -0, -0, -0.3743535, -0.1213411, 0.8724081, -0.3722163, 0.9955927, -0.238912, -0.189238, 1.091262, -0.1989275, -0.03127369, -0.2614089, -0.3749995, -0.3712254, -0.2086686, -0.3683111, -0.2245565, -0.1308042, -0.03643681, 0.2492909, -0, 0.6586378, -0.1233615, -0.1445363, 0.7103205, -0.2253736, -0.2502444, 0.9485985, -0.02232556, -0.368297, -0, 0.5862007, -0.3728159, -0.3481057, 0.5605552, -0.372416, -0.3747491, -0.3153846, -0.2594835, 0.5781407, -0.08041956, -0.2867912, -0.2965848, -0.336787, -0.2100661, -0.1150864, -0.2341067, 0.03802219, -0.1184845, 0.6722894, -0.2067484, 0.7498738, -0, -0.214396, 1.09564, -0.3687683, 0.8831186, 0.1735106, -0.3749886, -0.1835547, -0.2270784, -0.3439432, -0.3282675, 0.0123134, 0.3603124, -0.1330929, 0.8913264, -0.1233283, -0.3721971, -0.3062205, 0.7593479, -0, -0, -0.05970294, -0.3747103, -0.3622387, -0.3738016, -0.07933315, -0.2749595, -0.3573683, -0.3682009, 0.6933935, -0.2639669, 1.934702, -0.1146342, -0.3561518, -0.2364663, -0.3271146, -0.2908778, -0, 1.764824, -0.2068421, -0, 1.023883, -0.1281151, 0.6051717, -0.3347391, -0.01784253, 0.1740542, -0.3740751, -0.27122, -0, -0.2600461, -0, 0.08227016, -0.3633423, 0.4370711, -0.2110468, -0.04194125, -0, -0.271699, 0.7166933, -0.06413154, -0.2518682, -0.1822935, 0.7988848, -0.3102522, -0.3198274, -0.2038681, -0, -0.3738135, -0.3274397, -0.2202149, -0.3233624, 0.004502499, -0.3688813, -0, -0.1847965, -0, 0.2734478, 0.633977, -0.3265677, -0, -0.3534612, 0.2035268, -0.1350855, -0.3694168, -0.1498305, -0.374802, -0.3744542, 2.256192, -0.1107915, -0.358426, -0.3604715, 1.08173, 0.9750156, -0.1855858, -0.3743059, 0.9575425, -0.05012598, -0.2609594, -0.1002555, 0.5633581, -0.2652781, 0.7814329, 1.036063, 0.279767, 0.5833994, -0, 0.4761, 0.7103785, 0.3783974, -0, -0.1213253, -0, 1.341958, -0.05106708, -0, -0.1959043, -0, -0.2717902, -0.3496954, 0.4882478, -0.3709884, -0.2682391, -0.07853767, -0.2245321, -0, -0, -0.3183349, -0.3157946, 0.931049, -0.2296226, -0.3307717, -0, -0, -0.3363242, 0.08646077, 1.271552, -0.2081445, 0.04985015, -0.3749816, -0.0306966, -0, -0.352152, -0.1095497, -0.2284451, 1.297016, -0.2701979, -0.04880954, -0.03158856, 2.171259, -0.1193556, -0.06705771, 1.130807, -0.172193, 1.25489, -0.3042307, -0.1721122, -0.2009197, 0.6994622, -0.1282714, 1.169995, -0.2709107, 1.371508, 0.3536847, 0.3090905, 0.5675238, -0.3734051, 0.4862126, 1.429224, -0, -0.3140724, -0.3740117, -0, 0.3291153, -0.2951414, -0.1770975, 1.706688, -0.2897204, -0.3739994, -0, 1.555459, -0.3085323, -0.2269219, 0.1933583, -0.2071471, 0.03423361, -0, -0.3090197, 1.169981, -0.2212235, -0.3149344, 1.48904, -0.2243194, 0.04396741, -0.2872892, -0.01196522, 0.2044398, -0.3190661, -0, 0.2577906, -0.2228003, -0.02785708, -0.3365863, -0, 1.381425, 1.574282, -0, -0.2172095, -0.3747783, -0.3704655, -0.1153387, -0.05458141, -0, -0.3655647, -0.169563, -0, -0.3747264, -0.3448804, 1.183229, -0.01205562, 0.01854684, -0.373902, -0.2967637, -0.1475951, -0.07199503, -0.3625241, -0.3748668, -0.2857611, 0.321855, -0.33149, -0, -0.3741167, -0.3674679, -0.3747168, -0, -0.1892993, 0.08163172, -0.3046035, -0, -0.1457136, -0.2128585, -0.3643501, -0.1122154, -0.1867647, -0.2511791, -0, -0.25074, -0, 1.76437, 0.08004445, 0.2975841, -0.1884929, -0.3018849, -0.2844713, -0.3243271, -0, -0.2621516, -0.2016924, 1.018405, -0.2767258, -0.225181, 0.7010294, -0.2640987, -0.1546248, -0.09560105, 0.6578641, -0.3192261, -0, 1.062209, -0.3744643, -0.2962713, 0.2104271, -0.322905, -0, -0.287075, 1.142694, -0.2222336, 1.832134, 0.07406388, 1.198579, 1.670773, -0.2217826, -0.3733205, 0.2265467, -0.3617144, 0.02688701, 0.3406598, -0.3713803, -0, -0.2777968, -0.2722496, -0.3563129, -0.2979847, -0.2611049, -0, 1.423626, -0.240077, 0.04204613, -0.3507519, -0.2957686, -0, -0, -0.055907, -0.2819326, -0.3601303, -0.3706247, -0.04059377, -0.1205722, -0.1765944, -0.30023, 1.063469, 2.050074, -0.1072647, -0.09411168, -0, -0.3747773, -0.3558986, -0, -0.001018785, 0.8817818, 0.7684911, -0.1709324, 0.04503155, -0.129113, 0.8732532, -0.3511775, -0.03929636, -0, 0.1515744, -0.2285863, -0.3651176, -0.2217999, 0.1074391, 0.8906444, -0, -0.3276741, -0.2653251, -0.1831627, -0.3400108, -0, -0.08094011, -0.1965786, -0.3019477, 0.2447142, 1.208533, -0.03521511, -0.3702279, -0.3749654, 0.6855707, 0.02359082, -0.3227148, -0.2385628, -0.3568154, -0.3715849, -0.338076, -0, -0.3560959, 0.1965915, -0.2153797, -0.3706973, -0.3417692, -0.1370141, -0.3115385, -0.04786026, -0.340642, -0.3614548, -0.3635526, -0, -0.1080053, -0.2089973, -0.3659549, 0.4797131, -0.320809, -0, -0.2289792, 1.000035, -0, -0.06028073, 0.3387339, -0.1334511, -0.274877, 0.3337077, -0, -0.2692384, -0.3506845, -0.3276231, -0, -0, -0.2993403, 0.874421, -0.3747204, -0.3576775, -0.3616971, -0.0009746171, -0.316904, -0.01152862, -0, 0.6274835, 0.550741, 0.3188571, -0.2717923, -0, -0.3579066, -0.3315486, 0.634039, -0.3545521, 1.25704, -0.1347627, -0.3149446, -0, -0.2989559, -0.3070309, -0.3394933, -0.3675543, -0, 0.8626353, -0, -0.366246, -0.3630584, 0.5359813, -0.3684884, 0.126379, -0, 0.06547579, -0, -0.0695111, -0.3359713, 0.7404742, 0.5322065, -0.1509972, 0.5188971, 0.6549345, -0.220222, -0, -0.3749553, -0.3275233, -0.3748074, -0.3522291, 0.2784499, -0.3323376, -0.1075468, -0.3652236, -0.2423189, -0.351483, -0.3680624, -0, -0, -0.3312558, 0.6517833, -0.1042114, -0, -0.2347581, -0.1771557, -0.2122162, 0.5426448, -0.3744572, 0.1615877, -0.2958851, 0.4306451, -0.0643552, -0.3534998, -0, -0.3658144, -0.273343, -0.3591844, -0.2549123, 0.3345926, -0.2307809, -0.09270537, 0.4059354, 1.342165, -0.2988493, 3.772877, -0.2113828, 1.295721, -0.3747543, -0.3619624, -0.3568635, -0, 0.1386258, -0.3421244, 0.3531709, -0, 0.2291643, 0.003937064, -0.06930513, -0.3103371, -0, -0.2019204, -0.2663088, 0.2147804, -0.3158989, -0.2398679, -0.1932492, -0.3731991, -0.3452696, 0.4083887, -0.3644842, 1.650922, -0.3448791, -0.04977521, 0.2134301, -0.3612445, -0.1681335, -0.2867847, 0.002412132, 0.007702039, -0.3701673, 0.1736246, -0, -0.3123339, -0, 0.3747623, -0.2350999, 0.08246204, -0.108978, -0.3443654, -0.0948724, -0.3697905, -0.3586925, -0, -0.2528916, -0.3635862, 0.8867012, 1.081423, -0.3674649, 0.7413398, -0.09544046, -0.3088016, -0.3667349, -0.3296491, 0.1153949, -0.2645953, -0.1486708, -0.2962179, -0.03194798, 0.46523, 0.3710038, -0.1843818, -0.3620192, -0.3472948, 0.01481902, -0.1800266, -0.02733605, -0.2679552, 0.05392236, -0.3488196, -0.06243718, -0.374363, -0, 0.1453721, 0.4465654, -0.3183679, 0.1415854, 1.227921, -0.3607543, -0, -0.3059787, -0.07524256, -0.28198, 1.011233, -0.3685185, -0, -0.3609394, 1.018573, -0.2724634, -0, 0.04851035, -0.1826468, -0, -0.3557322, -0.374647, -0.2147251, -0.2563758, -0.1218013, -0, -0.3743495, -0, -0.2661612, -0.07848828, -0.3449442, -0, -0.2028366, 1.605031, 0.626785, -0.3743206, -0.3039663, -0.374269, -0.1858872, -0.1542852, -0, 1.328698, -0.1396515, -0.374577, 1.843432, 0.5668265, -0.3736134, -0.3453064, -0.3740651, -0.2641929, -0, -0.3063252, 0.02544488, -0.1033344, 0.5312461, -0.3056272, -0.01914435, -0.02798897, 0.08192389, -0.2348635, -0.2664489, -0.09395706, -0.361809, -0.2454167, -0.1971584, -0.1079013, -0, -0, -0.1356304, -0.3251651, 0.2051535, -0.3718253, -0.349645, -0, 0.01026984, -0.1214197, -0.1770319, 0.6697624, -0.05980928, 0.1326435, -0.1850534, -0.3523358, -0.3728671, -0.2986234, 0.06147983, -0.3068059, -0.1741133, -0.2965644, -0.3699502, 1.736827, -0.1927465, -0.2643048, -0.05824291, -0.08140597, -0.3387757, -0.3747725, 0.3143783, 0.3188643, -0, -0.1928627, -0, 1.542202, -0.2910214, 0.9342448, -0.3748536, -0.3100389, -0.1153676, -0.2251938, -0.03370571, -0.289453, -0, -0.2956506, 0.1811541
  ], quantizedEmbedding: nil, head: 0, headName: nil)


  func imageEmbedderWithModel(
    _ model: Model
  ) throws -> ImageEmbedderService {
    let imageEmbedderService = ImageEmbedderService.stillImageEmbedderService(
      model: model,
      delegate: .CPU)
    return imageEmbedderService!
  }

  func assertImageEmbedderResultHasOneHead(
    _ imageEmbedderResult: ImageEmbedderResult
  ) {
    XCTAssertEqual(imageEmbedderResult.embeddingResult.embeddings.count, 1)
    XCTAssertEqual(imageEmbedderResult.embeddingResult.embeddings[0].headIndex, 0)
  }

  func assertfloatDataAreEqual(
    embeddingData: NSNumber,
    expectedEmbeddingData: NSNumber,
    index: Int
  ) {
    XCTAssertEqual(
      Float(truncating: embeddingData),
      Float(truncating: expectedEmbeddingData),
      accuracy: 1e-3,
      String(
        format: """
              embeddingData[%d] and expectedEmbeddingData[%d] are not equal.
              """, index))
  }

  func assertEqualEmbeddingArrays(
    embedding: Embedding,
    expectedEmbedding: Embedding
  ) {
    XCTAssertEqual(
      embedding.floatEmbedding!.count,
      expectedEmbedding.floatEmbedding!.count)

    for (index, (embeddingData, expectedEmbeddingData)) in zip(embedding.floatEmbedding!, expectedEmbedding.floatEmbedding!)
      .enumerated()
    {
      assertfloatDataAreEqual(embeddingData: embeddingData, expectedEmbeddingData: expectedEmbeddingData, index: index)
    }
  }

  func assertResultsForEmbed(
    image: UIImage,
    using imageEmbedder: ImageEmbedderService,
    equals expectedEmbeddings: Embedding
  ) throws {
    let imageEmbedderResult =
    try XCTUnwrap(
      imageEmbedder.embed(image: image)!.imageEmbedderResults[0])
    assertImageEmbedderResultHasOneHead(imageEmbedderResult)
    assertEqualEmbeddingArrays(embedding: imageEmbedderResult.embeddingResult.embeddings[0], expectedEmbedding: expectedEmbeddings)
  }
  func testClassifyWithMobilenetV3SmallSucceeds() throws {

    let imageEmbedder = try imageEmbedderWithModel(
      ImageEmbedderTests.mobilenetV3Small)
    try assertResultsForEmbed(
      image: ImageEmbedderTests.testImage,
      using: imageEmbedder,
      equals: ImageEmbedderTests.mobilenetV3SmallEmbeddingResult)
  }

  func testClassifyWithMobilenetV3LargeSucceeds() throws {

    let imageEmbedder = try imageEmbedderWithModel(
      ImageEmbedderTests.mobilenetV3Large)
    try assertResultsForEmbed(
      image: ImageEmbedderTests.testImage,
      using: imageEmbedder,
      equals: ImageEmbedderTests.mobilenetV3LargeEmbeddingResult)
  }
}
