package com.punchin_punchout.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.punchin_punchout.services.TimeService;
import com.punchin_punchout.entities.TimeLog;

@RestController
@RequestMapping("/api/time-logs")
@CrossOrigin(origins = "*")
public class TimeController {

    @Autowired
    private TimeService timeService;

    @GetMapping("/healthcheck")
    public String healthcheck() {
        return "OK";
    }

    @PostMapping("/punch-in/{userId}")
    public ResponseEntity<?> punchIn(@PathVariable String userId) {
        try {
            return new ResponseEntity<>(timeService.punchIn(userId), HttpStatus.OK);
        } catch (IllegalStateException e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.CONFLICT);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    @PostMapping("/punch-out/{userId}")
    public ResponseEntity<?> punchOut(@PathVariable String userId) {
        try {
            return new ResponseEntity<>(timeService.punchOut(userId), HttpStatus.OK);
        } catch (IllegalStateException e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.CONFLICT);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping("/active/{userId}")
    public ResponseEntity<?> getCurrentTimeLog(@PathVariable String userId) {
        try {
            TimeLog timeLog = timeService.getCurrentTimeLog(userId);
            if (timeLog == null) {
                return ResponseEntity.notFound().build();
            }
            return ResponseEntity.ok(timeLog);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }
}
