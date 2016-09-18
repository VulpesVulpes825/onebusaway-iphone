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

#import <OBAKit/OBAPlacemarks.h>

@implementation OBAPlacemarks

- (id) init {
    self = [super init];
    if( self ) {
        _placemarks = [[NSMutableArray alloc] init];
        _attributions = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) addPlacemark:(OBAPlacemark*)placemark {
    [_placemarks addObject:placemark];
}

- (void) addAttribution:(NSString*)attribution {
    [_attributions addObject:attribution];
}

@end
