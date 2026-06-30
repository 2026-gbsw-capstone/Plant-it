package dev.siyoung.plantit.plantitbe.dto.common;

/**
 * 이메일/비밀번호/닉네임 입력값에 허용되는 문자 집합을 정의한다.
 * 이모지나 임의의 특수문자 등 의도치 않은 문자가 입력되는 문제를 막기 위해 사용한다.
 * 각 상수는 컴파일 타임 상수이므로 {@code @Pattern} 애너테이션에서 직접 참조할 수 있다.
 */
public final class ValidationPatterns {
    private ValidationPatterns() {
    }

    /** 표준 이메일 형식. 공백 및 비표준 문자를 허용하지 않는다. */
    public static final String EMAIL = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
    public static final String EMAIL_MESSAGE = "이메일 형식이 올바르지 않아요.";

    /** 영문/숫자와 일부 특수문자(!@#$%^&*()_+-=)만 허용한다. 공백·이모지·기타 특수문자는 불가. */
    public static final String PASSWORD = "^[A-Za-z0-9!@#$%^&*()_+\\-=]+$";
    public static final String PASSWORD_MESSAGE = "비밀번호는 영문, 숫자, 일부 특수문자(!@#$%^&*()_+-=)만 사용할 수 있어요.";

    /** 한글/영문/숫자/밑줄(_)만 허용하며 2~20자. 공백·이모지·기타 특수문자는 불가. */
    public static final String NICKNAME = "^[가-힣a-zA-Z0-9_]{2,20}$";
    public static final String NICKNAME_MESSAGE = "닉네임은 한글, 영문, 숫자, 밑줄(_)만 사용할 수 있고 2~20자여야 해요.";
}
