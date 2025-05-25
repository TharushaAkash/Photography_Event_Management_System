package com.example.event_booking_project_90.model;

public class Booking {
    private String bookingID;
    private String clientName;
    private String eventType;
    private String eventDate;
    private String location;
    private String photographerId;

    public Booking(String bookingID, String clientName, String eventType, String eventDate, String location, String photographerId) {
        this.bookingID     = bookingID;
        this.clientName    = clientName;
        this.eventType     = eventType;
        this.eventDate     = eventDate;
        this.location      = location;
        this.photographerId = photographerId;
    }

    public String toFileString() {
        return bookingID + ","
                + clientName + ","
                + eventType + ","
                + eventDate + ","
                + location + ","
                + photographerId;
    }

    public static Booking fromFileString(String str) {
        String[] parts = str.split(",");

        if (parts.length < 6) {
            String[] tmp = new String[6];
            for (int i = 0; i < 6; i++) {
                tmp[i] = i < parts.length ? parts[i] : "";
            }
            parts = tmp;
        }
        return new Booking(
                parts[0], parts[1], parts[2],
                parts[3], parts[4], parts[5]
        );
    }

    public String getBookingID()   { return bookingID;    }
    public String getClientName()  { return clientName;   }
    public String getEventType()   { return eventType;    }
    public String getEventDate()   { return eventDate;    }
    public String getLocation()    { return location;     }
    public String getPhotographerId() { return photographerId; }
}


