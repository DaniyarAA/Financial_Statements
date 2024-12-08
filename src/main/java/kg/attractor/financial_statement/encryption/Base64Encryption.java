package kg.attractor.financial_statement.encryption;

import java.nio.charset.StandardCharsets;
import java.util.Base64;

public class Base64Encryption {

    public static String encrypt(String plainText) {
        if (plainText == null || plainText.isBlank()) {
           return plainText;
        }

        return Base64.getEncoder().encodeToString(plainText.getBytes(StandardCharsets.UTF_8));
    }

    public static String decrypt(String cipherText) {
        if (cipherText == null || cipherText.isBlank()) {
           return cipherText;
        }

        byte[] decodedBytes = Base64.getDecoder().decode(cipherText);
        return new String(decodedBytes, StandardCharsets.UTF_8);
    }
}
