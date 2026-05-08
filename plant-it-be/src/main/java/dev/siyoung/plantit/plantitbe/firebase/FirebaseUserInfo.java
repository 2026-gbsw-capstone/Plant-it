package dev.siyoung.plantit.plantitbe.firebase;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class FirebaseUserInfo {
    private String uid;
    private String email;
    private String name;
    private String picture;
}
