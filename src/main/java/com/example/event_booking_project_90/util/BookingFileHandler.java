package com.example.event_booking_project_90.util;

import java.io.*;
import java.util.*;

public class BookingFileHandler {
    private static final String FILE_PATH = "C:/Users/Tharusha/Documents/Y1S2/Janithu_OOP/Event_Booking_System/src/main/webapp/resources/bookings.txt";

    public static void addBooking(
            String bookingId,
            String username,
            String eventId,
            String eventTitle,
            String bookingDate,
            String serviceTypes,
            String bookingLocation,
            String billingAddress,
            String billingCity,
            String billingZip,
            String status
    ) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(FILE_PATH, true))) {
            // Replace any commas in serviceTypes with pipe to avoid breaking CSV
            String safeServiceTypes = serviceTypes.replace(",", "|");
            // Optionally sanitize other fields too
            String safeTitle = eventTitle.replace(",", " ");
            String safeLocation = bookingLocation.replace(",", " ");
            String safeBillingAddress = billingAddress.replace(",", " ");
            String safeBillingCity = billingCity.replace(",", " ");

            bw.write(
                    bookingId + "," +
                            username + "," +
                            eventId + "," +
                            safeTitle + "," +
                            bookingDate + "," +
                            safeServiceTypes + "," +
                            safeLocation + "," +
                            safeBillingAddress + "," +
                            safeBillingCity + "," +
                            billingZip + "," +
                            status
            );
            bw.newLine();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static List<Map<String, String>> getAllBookings() {
        List<Map<String, String>> bookings = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] arr = line.split(",", -1);
                if (arr.length >= 11) {
                    Map<String, String> booking = new HashMap<>();
                    booking.put("id", arr[0]);
                    booking.put("username", arr[1]);
                    booking.put("eventId", arr[2]);
                    booking.put("eventTitle", arr[3]);
                    booking.put("bookingDate", arr[4]);
                    booking.put("serviceTypes", arr[5]); // stored as pipe-delimited
                    booking.put("bookingLocation", arr[6]);
                    booking.put("billingAddress", arr[7]);
                    booking.put("billingCity", arr[8]);
                    booking.put("billingZip", arr[9]);
                    booking.put("status", arr[10]);
                    bookings.add(booking);
                }
            }
        } catch (IOException e) {
            // handle or log
        }
        return bookings;
    }

    public static boolean updateBookingStatus(String bookingId, String status) {
        File inputFile = new File(FILE_PATH);
        File tempFile = new File(FILE_PATH + ".tmp");
        boolean updated = false;
        try (BufferedReader reader = new BufferedReader(new FileReader(inputFile));
             BufferedWriter writer = new BufferedWriter(new FileWriter(tempFile))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] arr = line.split(",", -1);
                if (arr.length >= 11 && arr[0].equals(bookingId)) {
                    arr[10] = status;
                    writer.write(String.join(",", arr));
                    updated = true;
                } else {
                    writer.write(line);
                }
                writer.newLine();
            }
        } catch (IOException e) {
            return false;
        }
        if (updated) {
            inputFile.delete();
            tempFile.renameTo(inputFile);
        } else {
            tempFile.delete();
        }
        return updated;
    }

    // Add this method to support editing bookings
    public static void overwriteBookings(List<Map<String, String>> bookings) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(FILE_PATH, false))) {
            for (Map<String, String> booking : bookings) {
                bw.write(
                    booking.get("id") + "," +
                    booking.get("username") + "," +
                    booking.get("eventId") + "," +
                    booking.get("eventTitle") + "," +
                    booking.get("bookingDate") + "," +
                    booking.get("serviceTypes") + "," +
                    booking.get("bookingLocation") + "," +
                    booking.get("billingAddress") + "," +
                    booking.get("billingCity") + "," +
                    booking.get("billingZip") + "," +
                    booking.get("status")
                );
                bw.newLine();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
