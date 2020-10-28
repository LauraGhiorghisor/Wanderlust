//
//  Constants.swift
//  MyApp
//
//  Created by Laura Ghiorghisor on 26/08/2020.
//  Copyright © 2020 Laura Ghiorghisor. All rights reserved.
//

struct K {
    
    static let appTitle = "WANDERLUST"
    
    
    

    
    // Segues
    static let registerToLoginSegue = "RegisterToLogin"
    static let singOutToLogin = "SignOutToLogin"
    static let loginToTabs = "LoginToTabs"
    static let chatToMsg = "ChatToMessages"
//    static let msgToChat = "MsgToChat"
//    static let tripsToNewTrip = "TripsToNewTrip"
    static let tripsToTripContent = "TripsToTripContent"
     static let tripsToNewTrip =  "TripsToNewTrip"
    static let tripContentToLocation = "TripContentToLocation"
    static let tripContentToEvents = "TripContentToEvents"
    static let tripToCompletedTrip =  "TripToCompletedTrip"
    static let eventsToNewEvent = "EventsToNewEvent"
    static let startToNewTrip = "StartToNewTrip"
    
    
    // new trip
    static let newTripToTripContent = "NewTripToTripContent"
    
    
    // For the chat functionality
    static let tripsCellIdentifier = "TripsReusableCell"
    static let msgCellIdentifier = "MsgReusableCell"
    // Nibs
    static let msgNibName = "MessageCell"
    static let tripNibName = "TripCell"
    
    // Trip
    static let tripContentAddNibName = "TripContentAddCell"
    static let tripContentShowNibName = "TripContentShowCell"
    static let tripContentCellIdentifier = "TripContentReusableCell"
    
    
    static let tripContentAddNameNibName = "TripContentAddNameCell"
    static let tripContentAddNameCellIdentifier = "TripContentAddNameCellIdentifier"
    static let tripContentAddLocationNibName = "TripContentAddLocationCell"
    static let tripContentAddLocationCellIdentifier = "TripContentAddLocationCellIdentifier"
    static let tripContentAddTuneNibName = "TripContentAddTuneCell"
    static let tripContentAddTuneCellIdentifier = "TripContentAddTuneCellIdentifier"
    static let tripContentAddStartDateNibName = "TripContentAddStartDateCell"
    static let tripContentAddStartDateCellIdentifier = "TripContentAddStartDateCellIdentifier"
    static let tripContentAddEndDateNibName = "TripContentAddEndDateCell"
    static let tripContentAddEndDateCellIdentifier = "TripContentAddEndDateCellIdentifier"
    
    
    
    
    static let newTripAddParticipantsNibName = "NewTripAddParticipantsCell"
    static let newTripAddParticipantsCellIdentifier = "NewTripAddParticipantsCellIdentifier"
    
    static let newTripShowParticipantsNibName = "NewTripShowParticipantsCell"
    static let newTripShowParticipantsCellIdentifier = "NewTripShowParticipantsCellIdentifier"
    
    // bg collection
    static let bgCellIdentifier = "BGCellIdentifier"
    static let bgCollectionViewCellNibName = "BGCollectionViewCell"
    static let bgCollectionViewCellIdentifier = "BGCollectionViewCellIndetifier"
    
    // events
    static let tripEventNibName = "TripEventCell"
    static let tripEventCellIdentifier = "TripEventCellIdentifier"
    
    //colours
    struct CorporateColours {
        static let orange = "BrandOrange"
        static let grey = "BrandGrey"
    }
    
    struct FStore {
        static let msgCollectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
        static let tripParentField = "trip"
    }
}
