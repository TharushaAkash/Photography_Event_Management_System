package com.example.event_booking_project_90.model;

public class Photography {
    private String id;
    private String title;
    private String date;
    private String location;
    private String description;
    private String username;
    private double price;

    public Photography() {
    }

    public Photography(String id, String title, String date, String location, String description, String username, double price) {
        this.id = id;
        this.title = title;
        this.date = date;
        this.location = location;
        this.description = description;
        this.username = username;
        this.price = price;
    }
    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }
}
