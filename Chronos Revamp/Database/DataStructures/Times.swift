//
//  startEndTimes.swift
//  STEM Chronos- Comp. Fair
//
//  Created by Nick Viscomi on 4/24/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit


struct Times {
    struct Regular {
        struct FS {
            struct OneSeven {
                static let OneSevenStartTimes = ["07:40 AM","08:39 AM","09:33 AM","10:27 AM","11:21 AM","11:55 AM","12:49 PM","01:43 PM","02:40 PM","12:00 AM",]
                static let OneSevenEndTimes = ["08:35 AM","09:29 AM","10:23 AM","11:17 AM","11:51 AM","12:45 PM","01:39 PM","02:40 PM","11:59 PM","07:40 AM"]
                static let OneSevenPeriodName = ["1st period","2nd period","3rd period","4th period","lunch","5th period","6th period","7th period", "after school", "before school"]
            }
            struct OneFour {
                static let OneFourStartTimes = ["07:40 AM","09:19 AM","10:53 AM","11:27 AM","01:01 PM","02:40 PM","12:00 AM"]
                static let OneFourEndTimes = ["09:15 AM","10:49 AM","11:23 AM","12:57 PM","02:40 PM","11:59 PM","07:40 AM"]
                static let OneFourPeriodName = ["1st period","2nd period","lunch","3rd period","4th period","after school", "before school"]
            }
            struct FiveSeven {
                static let FiveSevenStartTimes = ["07:40 AM","09:19 AM","09:58 AM","11:32 AM","12:05 PM","01:40 PM","02:40 PM","12:00 AM"]
                static let FiveSevenEndTimes = ["09:15 AM","09:54 AM","11:28 AM","12:02 PM","01:36 PM","02:40 PM","11:59 PM","07:40 AM"]
                static let FiveSevenPeriodName = ["5th period","advisory","6th period","lunch","7th period","seminar","after school", "before school"]
            }
        }
        struct JS {
            struct OneSeven {
                static let OneSevenStartTimes = ["07:40 AM","08:39 AM","09:33 AM","10:27 AM","11:21 AM","12:15 PM","12:49 PM","01:43 PM","02:40 PM","12:00 AM",]
                static let OneSevenEndTimes = ["08:35 AM","09:29 AM","10:23 AM","11:17 AM","12:11 PM","12:45 PM","01:39 PM","02:40 PM","11:59 PM","07:40 AM"]
                static let OneSevenPeriodName = ["1st period","2nd period","3rd period","4th period","5th period","lunch","6th period","7th period", "after school", "before school"]
            }
            struct OneFour {
                static let OneFourStartTimes = ["07:40 AM","09:19 AM","10:53 AM","12:27 PM","01:01 PM","02:40 PM","12:00 AM"]
                static let OneFourEndTimes = ["09:15 AM","10:49 AM","12:23 PM","12:57 PM","02:40 PM","11:59 PM","07:40 AM"]
                static let OneFourPeriodName = ["1st period","2nd period","3rd period","lunch","4th period","after school", "before school"]
            }
            struct FiveSeven {
                static let FiveSevenStartTimes = ["07:40 AM","09:19 AM","09:58 AM","11:32 AM","01:05 PM","01:40","02:40 PM","12:00 AM"]
                static let FiveSevenEndTimes = ["09:15 AM","09:54 AM","11:28 AM","01:02 PM","01:36 PM","02:40 PM","11:59 PM","07:40 AM"]
                static let FiveSevenPeriodName = ["5th period","advisory","6th period","7th period","lunch","seminar","after school", "before school"]
            }
        }
    }//end regular
    struct TwoHrEarly {
        struct FS {
            struct OneSeven {
                static let OneSevenStartTimes = ["07:40 AM","08:22 AM","09:00 AM","09:38 AM","10:16 AM","10:49 AM","11:27 AM","12:05 PM", "12:41 PM", "12:00 AM"]
                static let OneSevenEndTimes = ["08:19 AM","08:57 AM","09:35 AM","10:13 AM","10:46 AM","11:24 AM","12:02 PM","12:40 PM", "11:59 PM", "07:39 AM"]
                static let OneSevenPeriodName = ["1st period","2nd period","3rd period","4th period","lunch","5th period","6th period","7th period", "after school", "before school"]
            }
            struct OneFour {
                static let OneFourStartTimes = ["07:40 AM","08:48 AM","09:56 AM","11:03 AM","11:36 AM", "12:41 PM", "12:00 AM"]
                static let OneFourEndTimes = ["08:44 AM","09:52 AM","11:00 AM","11:33 AM","12:40 PM", "11:59 PM", "07:39 AM"]
                static let OneFourPeriodName = ["1st period","2nd period","3rd period","lunch","4th period", "after school", "before school"]
            }
            struct FiveSeven {
                static let FiveSevenStartTimes = ["07:40 AM","08:58 AM","10:16 AM","10:49 AM","12:08 PM", "12:41 PM", "12:00 AM"]
                static let FiveSevenEndTimes = ["08:55 AM","10:13 AM","10:46 AM","12:04 PM","12:40 PM", "11:59 PM", "07:39 AM"]
                static let FiveSevenPeriodName = ["5th period","6th period","lunch","7th period","seminar","after school", "before school"]
            }
        }
        struct JS {
            struct OneSeven {
                static let OneSevenStartTimes = ["07:40 AM","08:22 AM","09:00 AM","09:38 AM","10:16 AM","10:54 AM","11:27 AM","12:05 PM", "12:41 PM", "12:00 AM"]
                static let OneSevenEndTimes = ["08:19 AM","08:57 AM","09:35 AM","10:13 AM","10:51 AM","11:24 AM","12:02 PM","12:40 PM", "11:59 PM", "07:39 AM"]
                static let OneSevenPeriodName = ["1st period","2nd period","3rd period","4th period","5th period","lunch","6th period","7th period", "after school", "before school"]
            }
            struct OneFour {
                static let OneFourStartTimes = ["07:40 AM","08:48 AM","09:56 AM","11:03 AM","12:10 PM","12:41 PM","12:00 AM"]
                static let OneFourEndTimes = ["08:44 AM","09:52 AM","11:00 AM","12:07 PM","12:40 PM", "11:59 PM", "07:39 AM"]
                static let OneFourPeriodName = ["1st period","2nd period","3rd period","4th period","lunch", "after school", "before school"]
            }
            struct FiveSeven {
                static let FiveSevenStartTimes = ["07:40 AM","08:58 AM","10:16 AM","11:34 AM","12:08 PM", "12:41 PM", "12:00 AM"]
                static let FiveSevenEndTimes = ["08:55 AM","10:13 AM","11:31 AM","12:04 PM","12:40 PM", "11:59 PM", "07:39 AM"]
                static let FiveSevenPeriodName = ["5th period","6th period","7th period","lunch","seminar","after school", "before school"]
            }
        }
        
    }//end 2hr earlt
    
    struct TwoHrDelay {
        struct FS {
            struct OneSeven {
                static let OneSevenStartTimes = ["09:40 AM","10:22 AM","11:00 AM","11:38 AM","12:16 PM", "12:49 PM","01:27 PM","02:05 PM","02:41 PM","12:00 PM"]
                static let OneSevenEndTimes = ["10:19 AM","10:57 AM","11:35 AM","12:13 PM","12:46 PM","01:24 PM","02:02 PM","02:40 PM","11:59 PM","07:39 PM"]
                static let OneSevenPeriodName = ["1st period","2nd period","3rd period","4th period","lunch","5th period","6th period","7th period", "after school", "before school"]
            }
            struct OneFour {
                static let OneFourStartTimes = ["09:40 AM","10:48 AM","11:56 AM","12:27 PM","01:36 PM", "02:41 PM", "12:00 AM"]
                static let OneFourEndTimes = ["10:44 AM","11:52 AM","12:24 PM","01:33 PM","02:40 PM", "11:59 PM", "07:39 AM"]
                static let OneFourPeriodName = ["1st period","2nd period","lunch","3rd period","4th period", "after school", "before school"]
            }
            struct FiveSeven {
                static let FiveSevenStartTimes = ["09:40 AM","10:58 AM","12:16 PM","12:49 PM","02:08 PM", "02:41 PM", "12:00 AM"]
                static let FiveSevenEndTimes = ["10:55 AM","12:13 PM","12:46 PM","02:04 PM","02:40 PM", "11:59 PM", "07:39 AM"]
                static let FiveSevenPeriodName = ["5th period","6th period","lunch","7th period","seminar","after school", "before school"]
            }
        }
        struct JS {
            struct OneSeven {
                static let OneSevenStartTimes = ["09:40 AM","10:22 AM","11:00 AM","11:38 AM","12:16 PM", "12:54 PM","01:27 PM","02:05 PM","02:41 PM","12:00 PM"]
                static let OneSevenEndTimes = ["10:19 AM","10:57 AM","11:35 AM","12:13 PM","12:51 PM","01:24 PM","02:02 PM","02:40 PM","11:59 PM","07:39 PM"]
                static let OneSevenPeriodName = ["1st period","2nd period","3rd period","4th period","5th period","lunch","6th period","7th period", "after school", "before school"]
            }
            struct OneFour {
                static let OneFourStartTimes = ["09:40 AM","10:48 AM","11:56 AM","01:03 PM","01:36 PM", "02:41 PM", "12:00 AM"]
                static let OneFourEndTimes = ["10:44 AM","11:52 AM","01:00 PM","01:33 PM","02:40 PM", "11:59 PM", "07:39 AM"]
                static let OneFourPeriodName = ["1st period","2nd period","3rd period","lunch","4th period", "after school", "before school"]
            }
            struct FiveSeven {
                static let FiveSevenStartTimes = ["09:40 AM","10:58 AM","12:16 PM","01:34 PM","02:08 PM", "02:41 PM", "12:00 AM"]
                static let FiveSevenEndTimes = ["10:55 AM","12:13 PM","01:31 PM","02:04 PM","02:40 PM", "11:59 PM", "07:39 AM"]
                static let FiveSevenPeriodName = ["5th period","6th period","7th period","lunch","seminar","after school", "before school"]
            }
        }
        
    }
    

}
