package com.example.roomapp.model;

import jakarta.persistence.*;

@Entity
@Table(name = "rooms")
public class Room {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String type;
    private double area;
    private double pricePerNight;

    // Default constructor
    public Room() {}

    // Constructor with fields
    public Room(String type, double area, double pricePerNight) {
        this.type = type;
        this.area = area;
        this.pricePerNight = pricePerNight;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public double getArea() {
        return area;
    }

    public void setArea(double area) {
        this.area = area;
    }

    public double getPricePerNight() {
        return pricePerNight;
    }

    public void setPricePerNight(double pricePerNight) {
        this.pricePerNight = pricePerNight;
    }

    // Optional: toString for debugging
    @Override
    public String toString() {
        return "Room{" +
                "id=" + id +
                ", type='" + type + '\'' +
                ", area=" + area +
                ", pricePerNight=" + pricePerNight +
                '}';
    }
}
