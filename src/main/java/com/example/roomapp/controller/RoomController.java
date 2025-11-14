package com.example.roomapp.controller;

import com.example.roomapp.model.Room;
import com.example.roomapp.repository.RoomRepository;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/rooms")
public class RoomController {

    private final RoomRepository roomRepository;

    public RoomController(RoomRepository roomRepository) {
        this.roomRepository = roomRepository;
    }

    @GetMapping
    public List<Room> getAllRooms() {
        return roomRepository.findAll();
    }

    @GetMapping("/{id}")
    public Optional<Room> getRoom(@PathVariable Long id) {
        return roomRepository.findById(id);
    }

    @PostMapping
    public Room createRoom(@RequestBody Room room) {
        return roomRepository.save(room);
    }

    @PutMapping("/{id}")
    public Room updateRoom(@PathVariable Long id, @RequestBody Room updatedRoom) {
        return roomRepository.findById(id)
            .map(room -> {
                room.setType(updatedRoom.getType());
                room.setArea(updatedRoom.getArea());
                room.setPricePerNight(updatedRoom.getPricePerNight());
                return roomRepository.save(room);
            }).orElseGet(() -> {
                updatedRoom.setId(id);
                return roomRepository.save(updatedRoom);
            });
    }

    @DeleteMapping("/{id}")
    public void deleteRoom(@PathVariable Long id) {
        roomRepository.deleteById(id);
    }
}
