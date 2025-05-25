package com.example.event_booking_project_90.util;

import com.example.event_booking_project_90.model.Booking;
import javax.servlet.ServletContext;

import java.io.*;
import java.util.LinkedList;
import java.util.Queue;

public class BookingManagement {
    private String filePath;
    private Queue<Booking> queue = new LinkedList<>();

    public BookingManagement(ServletContext context) {
        this.filePath = context.getRealPath("Booking.txt");
        loadFromFile();
    }

    public void addBooking(Booking booking) {
        queue.add(booking);
        saveToFile();
    }

    public Booking processBooking() {
        Booking b = queue.poll();
        saveToFile();
        return b;
    }

    public Queue<Booking> getAllBookings() {
        return queue;
    }

    private void saveToFile() {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(filePath))) {
            for (Booking booking : queue) {
                writer.write(booking.toFileString());
                writer.newLine();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void loadFromFile() {
        queue.clear();
        try (BufferedReader reader = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                queue.add(Booking.fromFileString(line));
            }
        } catch (IOException e) {

        }
    }

    public String getNextBookingID() {
        int maxId = 0;
        try {
            BufferedReader reader = new BufferedReader(new FileReader(filePath));
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                String[] parts = line.split(",");
                if (parts.length > 0 && parts[0].startsWith("N")) {
                    try {
                        int idNum = Integer.parseInt(parts[0].substring(1));
                        if (idNum > maxId) {
                            maxId = idNum;
                        }
                    } catch (NumberFormatException e) {

                    }
                }
            }
            reader.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return String.format("N%03d", maxId + 1);
    }


}

