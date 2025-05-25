package com.example.event_booking_project_90.util;


import com.example.event_booking_project_90.model.Photography;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class PhotoEventFileHandler {
    private static final String EVENTS_FILE_PATH = "C:/Users/Tharusha/Documents/Y1S2/Janithu_OOP/Event_Booking_System/src/main/webapp/resources/photo_events.txt";

    // Save a new photography event
    public static synchronized boolean saveEvent(Photography event) {
        try {
            List<Photography> events = getAllEvents();

            // Generate unique ID if not provided
            if (event.getId() == null || event.getId().isEmpty()) {
                event.setId(UUID.randomUUID().toString());
            }

            events.add(event);
            return writeAllEvents(events);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all photography events
    public static List<Photography> getAllEvents() {
        List<Photography> events = new ArrayList<>();
        File file = new File(EVENTS_FILE_PATH);

        // Return empty list if file doesn't exist
        if (!file.exists()) {
            return events;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    Photography event = parseEventFromLine(line);
                    if (event != null) {
                        events.add(event);
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        return events;
    }

    // Parse event from line
    private static Photography parseEventFromLine(String line) {
        try {
            String[] parts = line.split("\\|");
            if (parts.length >= 5) {
                Photography event = new Photography();
                event.setId(parts[0]);
                event.setTitle(parts[1]);
                event.setDate(parts[2]);
                event.setLocation(parts[3]);
                event.setDescription(parts[4]);
                if (parts.length > 5) {
                    event.setUsername(parts[5]);
                }
                // Handle price field
                if (parts.length > 6) {
                    event.setPrice(Double.parseDouble(parts[6]));
                }
                return event;
            }
        } catch (Exception e) {
            System.err.println("Error parsing line: " + line);
            e.printStackTrace();
        }
        return null;
    }

    // Get events by a specific user
    public static List<Photography> getEventsByUsername(String username) {
        List<Photography> allEvents = getAllEvents();
        List<Photography> userEvents = new ArrayList<>();

        for (Photography event : allEvents) {
            if (event.getUsername().equals(username)) {
                userEvents.add(event);
            }
        }

        return userEvents;
    }

    // Get a single event by ID
    public static Photography getEventById(String eventId) {
        List<Photography> events = getAllEvents();

        for (Photography event : events) {
            if (event.getId().equals(eventId)) {
                return event;
            }
        }

        return null;
    }

    // Update an existing event
    public static boolean updateEvent(Photography updatedEvent) {
        List<Photography> events = getAllEvents();

        for (int i = 0; i < events.size(); i++) {
            if (events.get(i).getId().equals(updatedEvent.getId())) {
                events.set(i, updatedEvent);
                return writeAllEvents(events);
            }
        }

        return false;
    }

    // Delete an event
    public static boolean deleteEvent(String eventId) {
        List<Photography> events = getAllEvents();
        boolean removed = events.removeIf(event -> event.getId().equals(eventId));

        if (removed) {
            return writeAllEvents(events);
        }

        return false;
    }

    // Write all events to the text file
    private static boolean writeAllEvents(List<Photography> events) {
        try {
            File file = new File(EVENTS_FILE_PATH);
            if (!file.exists()) {
                file.getParentFile().mkdirs();
            }

            try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
                for (Photography event : events) {
                    writer.write(convertEventToLine(event));
                    writer.newLine();
                }
                return true;
            }
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Convert event to text line
    private static String convertEventToLine(Photography event) {
        StringBuilder sb = new StringBuilder();
        sb.append(event.getId()).append("|");
        sb.append(event.getTitle()).append("|");
        sb.append(event.getDate()).append("|");
        sb.append(event.getLocation()).append("|");
        sb.append(event.getDescription()).append("|");
        sb.append(event.getUsername() != null ? event.getUsername() : "").append("|");
        // Include price in the output line
        sb.append(event.getPrice());
        return sb.toString();
    }
}