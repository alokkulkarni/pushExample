import Foundation
import MapKit
import CoreLocation


/// Define the accuracy of request
///
/// - IPScan: Use geolocation via IP address scan. It very efficent and does not require user authorization, however accuracy is very low (city based at the best)
/// - any: Lowest accuracy (< 1000km is accepted)
/// - country: Lower accuracy (< 100km is accepted)
/// - city: City accuracy (<= 3km is accepted)
/// - neighborhood: Neighborhood accuracy (less than a kilometer is accepted)
/// - block: Block accuracy (hundred meters are accepted)
/// - house: House accuracy (nearest ten meters are accepted)
/// - room: Best accuracy
/// - navigation: Best accuracy specific for navigation purposes
public enum Accuracy: CustomStringConvertible {
	case IPScan(_: IPService)
	case any
	case country
	case city
	case neighborhood
	case block
	case house
	case room
	case navigation
	
	/// Order by accuracy
	internal var orderValue: Int {
	switch self {
	case .IPScan(_):	return 0
	case .any:			return 1
	case .country:		return 2
	case .city:			return 3
	case .neighborhood:	return 4
	case .block:		return 5
	case .house:		return 6
	case .room:			return 7
	case .navigation:	return 8
	}
	}
	
	/// Accuracy measured in meters
	public var level: CLLocationDistance {
		switch self {
		case .IPScan(_):	return Double.infinity
		case .any:			return 1000000.0
		case .country:		return 100000.0
		case .city:			return kCLLocationAccuracyThreeKilometers
		case .neighborhood:	return kCLLocationAccuracyKilometer
		case .block:		return kCLLocationAccuracyHundredMeters
		case .house:		return kCLLocationAccuracyNearestTenMeters
		case .room:			return kCLLocationAccuracyBest
		case .navigation:	return kCLLocationAccuracyBestForNavigation
		}
	}
	
	/// Validation level in meters
	public var threshold: Double {
		switch self {
		case .IPScan(_):	return Double.infinity
		case .any:			return 1000000.0
		case .country:		return 100000.0
		case .city:			return 5000.0
		case .neighborhood:	return 1000.0
		case .block:		return 100.0
		case .house:		return 15.0
		case .room:			return 5.0
		case .navigation:	return 5.0
		}
	}
	
	/// Validate given `location` against the current accuracy.
	///
	/// - Parameter location: location to validate
	/// - Returns: `true` if valid, `false` otherwise
	public func isValid(_ location: CLLocation) -> Bool {
		switch self {
		case .room, .navigation:
			// This because kCLLocationAccuracyBest and kCLLocationAccuracyBestForNavigation
			// are not real values but only placeholder for a particular accuracy type
			// and values depended by the hardware.
			return (location.horizontalAccuracy < kCLLocationAccuracyNearestTenMeters)
		default:
			// Otherwise we can check meters
			return (location.horizontalAccuracy <= self.threshold)
		}
	}
	
	
	/// CoreLocation user authorizations are required for this accuracy
	public var requestUserAuth: Bool {
		get {
			guard case .IPScan(_) = self else { // only ip-scan does not require auth
				return true
			}
			return false
		}
	}
	
	/// Description of the accuracy
	public var description: String {
		switch self {
		case .IPScan(let service):		return "IPScan \(service)"
		case .any:						return "Any"
		case .country:					return "Country"
		case .city:						return "City"
		case .neighborhood:				return "Neighborhood (\(self.threshold) meters)"
		case .block:					return "Block (\(self.threshold) meters)"
		case .house:					return "House (\(self.threshold) meters)"
		case .room:						return "Room"
		case .navigation:				return "Navigation"
		}
	}
}
