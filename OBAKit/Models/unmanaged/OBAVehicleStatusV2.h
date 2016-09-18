/**
 * Copyright (C) 2009-2016 bdferris <bdferris@onebusaway.org>, University of Washington
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <OBAKit/OBAHasReferencesV2.h>
#import <OBAKit/OBATripV2.h>
#import <OBAKit/OBATripStatusV2.h>

NS_ASSUME_NONNULL_BEGIN

@interface OBAVehicleStatusV2 : OBAHasReferencesV2

@property (nonatomic,strong) NSString * vehicleId;
@property (nonatomic) long long lastUpdateTime;

@property (nonatomic,strong) NSString * tripId;
@property (weak, nonatomic,readonly) OBATripV2 * trip;

@property (nonatomic,strong) OBATripStatusV2 * tripStatus;

@end

NS_ASSUME_NONNULL_END
