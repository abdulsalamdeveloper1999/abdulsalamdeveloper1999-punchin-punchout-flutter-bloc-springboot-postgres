package com.punchin_punchout.controllers;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.punchin_punchout.entities.UserEntity;
import com.punchin_punchout.repositories.UserRepo;
import com.punchin_punchout.utils.IdGenerator;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/api/user")
@Slf4j
public class UserController {

    @Autowired
    private UserRepo userRepo;

    private IdGenerator idGenerator;


    public UserController(IdGenerator idGenerator) {
        this.idGenerator = idGenerator;
    }


    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody UserEntity user)throws Exception {
        try {
            UserEntity byUsername = userRepo.findByUsername(user.getUsername());
        if (byUsername != null) {
            return new ResponseEntity<>("User already exists",HttpStatus.ALREADY_REPORTED);
        } else {
           user.setId(IdGenerator.generate7DigitId());
           UserEntity newuser= userRepo.save(user);
            // Map<String,String> response=new HashMap<>();
            // response.put("User Registered Successfully here is ur id:",newuser.getId() );
            return new ResponseEntity<>(newuser,HttpStatus.OK);
        }
        
        } catch (Exception e) {
            log.error(e.getMessage(), "");
            throw new IllegalAccessException(e.getMessage());
        }
    }


    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody UserEntity user) {
        UserEntity byUsername = userRepo.findByUsername(user.getUsername());
        if (byUsername == null) {
            return new ResponseEntity<>("User not found", HttpStatus.NOT_FOUND);
        }
        if (byUsername.getPassword().equals(user.getPassword())) {
            return new ResponseEntity<>(byUsername, HttpStatus.OK);
        }
        return new ResponseEntity<>("Invalid password", HttpStatus.UNAUTHORIZED);
    
    
    
}
}
