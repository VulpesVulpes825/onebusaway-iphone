/**
 * Copyright (C) 2009 bdferris <bdferris@onebusaway.org>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *         http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "OBAStopAndPredictedArrivalsSearch.h"
#import "OBAArrivalAndDeparture.h"
#import "OBAProgressIndicatorImpl.h"
#import "OBACommon.h"
#import "OBAJsonDataSource.h"


@implementation OBAStopAndPredictedArrivalsSearch

@synthesize stop = _stop;
@synthesize predictedArrivals = _predictedArrivals;
@synthesize progress = _progress;
@synthesize error = _error;

- (id) initWithContext:(OBAApplicationContext*)context {
	if( self = [super init] ) {
		_context = [context retain];
		_progress = [[OBAProgressIndicatorImpl alloc] init];
		_jsonDataSource = [[OBAJsonDataSource alloc] initWithConfig:context.obaDataSourceConfig];
		_modelFactory = [context.modelFactory retain];
		_modelDao = [context.modelDao retain];
	}
	return self;
}
	
- (void) dealloc {

	[self cancelOpenConnections];
	
	[_stopId release];
	[_stop release];
	[_predictedArrivals release];
	[_progress release];	
	[_error release];
	
	[_jsonDataSource release];
	[_modelFactory release];
	[_modelDao release];
	
	[_context release];
	
	[super dealloc];
}

- (void) searchForStopId:(NSString*)stopId {
	_stopId = [stopId retain];
	[self refresh];
}

- (OBANavigationTarget*) getSearchTarget {
	if( ! _stopId )
		return nil;
	NSDictionary * params = [NSDictionary dictionaryWithObject:_stopId forKey:@"stopId"];
	return [OBANavigationTarget target:OBANavigationTargetTypeStop parameters:params];
}

-(void) setSearchTarget:(OBANavigationTarget*) target {
	NSString * stopId = [target parameterForKey:@"stopId"];
	[self searchForStopId:stopId];
}

- (void) cancelOpenConnections {
	[_jsonDataSource cancelOpenConnections];
}

- (void) refresh {
	if( _stopId ) {
		NSString *url = [NSString stringWithFormat:@"/api/where/arrivals-and-departures-for-stop/%@.json", _stopId];
		[_progress setMessage:@"Connecting..." inProgress:TRUE progress:0];
		[_jsonDataSource requestWithPath:url withArgs:nil withDelegate:self context:nil];	
	}
}

- (void)connectionDidFinishLoading:(id<OBADataSourceConnection>)connection withObject:(id)obj context:(id)context{
	
	NSNumber * code = [obj valueForKey:@"code"];
	
	if( code == nil || [code intValue] != 200 ) {
		self.error = [OBAErrorCodes getErrorFromResponseCode:[code intValue]];
		return;
	}
	
	NSDictionary * data = [obj valueForKey:@"data"];
	
	NSError * localError = nil;	
	OBAArrivalsAndDeparturesForStop * ads = [_modelFactory getArrivalsAndDeparturesForStopFromJSON:data error:&localError];
	if( localError ) {
		self.error = localError;
		return;
	}
	
	// Note the event
	[_context.activityListeners viewedArrivalsAndDeparturesForStop:ads.stop];

	// Update the page
	self.stop = ads.stop;
	self.predictedArrivals = ads.arrivalsAndDepartures;
	self.error = nil;
	
	NSString * message = [NSString stringWithFormat:@"Updated: %@", [OBACommon getTimeAsString]];
	[_progress setMessage:message inProgress:FALSE progress:0];
}

- (void)connection:(id<OBADataSourceConnection>)connection withProgress:(float)progress {
	[_progress setInProgress:TRUE progress:progress];
}

- (void)connectionDidFail:(id<OBADataSourceConnection>)connection withError:(NSError *)error context:(id)context {
	NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription],[[error userInfo] objectForKey:NSErrorFailingURLStringKey]);	
	self.error = error;
	[_progress setMessage:@"Error connecting" inProgress:FALSE progress:0];
}

@end