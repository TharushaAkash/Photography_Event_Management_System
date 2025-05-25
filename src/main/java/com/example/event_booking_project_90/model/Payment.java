package com.example.event_booking_project_90.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Payment {
    private String name;
    private String cardNumber;
    private String amount;
    private String timestamp;

    public Payment(String name, String cardNumber, String amount) {
        this.name = (name != null && !name.isEmpty()) ? name : "Not provided";
        this.cardNumber = cardNumber; // Card number will be masked when retrieved
        this.amount = (amount != null && !amount.isEmpty()) ? amount : "Not provided";
        this.timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
    }

    public String getName() {
        return name;
    }

    public String getMaskedCardNumber() {
        if (cardNumber != null && cardNumber.length() >= 4) {
            return "**** **** **** " + cardNumber.substring(cardNumber.length() - 4);
        }
        return "**** **** **** ****";
    }

    public String getAmount() {
        return amount;
    }

    public String getTimestamp() {
        return timestamp;
    }

    // For saving to file
    public String toFileString() {
        return name + "," + cardNumber + "," + amount;
    }
}