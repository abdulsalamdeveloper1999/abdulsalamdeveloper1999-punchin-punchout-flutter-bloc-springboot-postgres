package com.punchin_punchout.services;

import java.time.Duration;

import java.time.LocalDateTime;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.punchin_punchout.entities.TimeLog;

import com.punchin_punchout.repositories.TimeLogRepo;
import com.punchin_punchout.repositories.UserRepo;

@Service
public class TimeService {

    @Autowired
    private TimeLogRepo timeLogRepo;

    @Autowired
    private UserRepo userRepo;

    public TimeLog punchIn(String userId) {
        // Check if user is already punched in
        Optional<TimeLog> activeLog = timeLogRepo.findActivePunchIn(userId);
        if (activeLog.isPresent()) {
            throw new IllegalStateException("User is already punched in");
        }

        // Create new punch in log
        TimeLog newLog = new TimeLog();
        newLog.setUserId(userId);
        newLog.setPunchIn(LocalDateTime.now());
        return timeLogRepo.save(newLog);
    }

    public TimeLog punchOut(String userId) {
        // Get active punch in log
        Optional<TimeLog> activeLog = timeLogRepo.findActivePunchIn(userId);
        if (activeLog.isEmpty()) {
            throw new IllegalStateException("No active punch in found for user");
        }

        // Update with punch out time
        TimeLog log = activeLog.get();
        log.setPunchOut(LocalDateTime.now());
        log.setDuration(Duration.between(log.getPunchIn(), log.getPunchOut()).toMinutes());
        return timeLogRepo.save(log);
    }

    public TimeLog getCurrentTimeLog(String userId) {
        return timeLogRepo.findActivePunchIn(userId).orElse(null);
    }

    // public TimeLog getTimeLogs(String id){
    //     UserEntity byUsername = userRepo.findById(id).orElse(null);
    //     if (byUsername == null) {
    //         return null;
    //     }
    //     return timeLogRepo.findByUserId(byUsername.getId());
    // }





    
}
