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
//    static let registerToLoginSegue = "RegisterToLogin"
    static let registerToTrips = "RegisterToTrips"
    static let singOutToLogin = "SignOutToLogin"
    static let loginToTabs = "LoginToTabs"
    static let chatToMsg = "ChatToMessages"
//    static let msgToChat = "MsgToChat"
//    static let tripsToNewTrip = "TripsToNewTrip"
    static let tripsToTripContent = "TripsToTripContent"
    static let tripsToVotingClosed = "TripsToVotingClosed"
     static let tripsToNewTrip =  "TripsToNewTrip"
    static let tripContentToLocation = "TripContentToLocation"
    static let tripContentToEvents = "TripContentToEvents"
    static let tripToCompletedTrip =  "TripToCompletedTrip"
    static let startToNewTrip = "StartToNewTrip"
    static let startToModalUpgrade = "StartToModalUpgrade"
    static let openToVoted = "OpenToVoted"
    static let votedToEvents = "VotedToEvents"
    
    // new trip
    static let newTripToTripContent = "NewTripToTripContent"
    static let tripContentToNotes = "TripContentToNotes"
    static let settingsToAccount = "SettingsToAccount"
    
    
    // modal
    static let contentToAddPeopleModal = "ContentToAddPeopleModal"
    static let votedToAddPeopleModal = "VotedToAddPeopleModal"
    static let votedToUpgradeModal = "VotedToUpgradeModal"
    
    //settings
    static let settingsToReportAProblem = "SettingsToReportAProblem"
    static let settingsToTC = "SettingsToTC"
    
    static let eventCellToMap = "EventCellToMap"
    static let eventsToNewEvent = "EventsToNewEvent"
    static let viewAllToEvents = "ViewAllToEvents"
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
    
    
    // alert
    static let alertCellNibName = "AlertCell"
    static let alertCellIdentifier = "AlertCellIdentifier"
    
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
        static let teal = "BrandTeal"
        static let green = "BrandGreen"
        static let black = "BrandBlack"
        static let brightOrange = "BrandBrightOrange"
        static let darkTeal = "BrandDarkTeal"
    }
    
    struct FStore {
        static let msgCollectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
        static let tripParentField = "trip"
    }
    
    struct status {
        static let brainstormingOpen = "Brainstorming open"
        static let votingOpen = "Voting open"
        static let votingClosed = "Voting closed"
    }
    struct alert {
        static let pending = "pending"
        static let accepted = "accepted"
        static let declined = "declined"
    }
    
    
    static let chatTripCellNib = "ChatTripCell"
    static let chatTripCellIdentifier = "chatTripCellIdentifier"
    
    static let loggedInCellNib = "LoggedInCell"
    static let loggedInCellIdentifier = "LoggedInCellIdentifier"
    
    static let settingsCellNib = "SettingsCell"
    static let settingsCellIdentifier = "SettingsCellIdentifier"
    
    static let tripMojiCell = "TripMojiCell"
    static let tripMojiCellNibName = "TripMojiCell"
}
