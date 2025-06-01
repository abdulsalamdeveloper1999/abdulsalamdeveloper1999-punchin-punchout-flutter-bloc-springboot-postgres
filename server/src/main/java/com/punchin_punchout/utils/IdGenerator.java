package com.punchin_punchout.utils;

import java.security.SecureRandom;

import org.springframework.stereotype.Component;

@Component
public class IdGenerator {

    private static final SecureRandom RANDOM = new SecureRandom();

    public static String generate7DigitId() {
        int number = 1000000 + RANDOM.nextInt(9000000); 
        // ensures number is between 1,000,000 and 9,999,999 (7 digits)
        return String.valueOf(number);
    }
}
