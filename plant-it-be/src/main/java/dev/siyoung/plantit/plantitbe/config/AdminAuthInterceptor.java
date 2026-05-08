package dev.siyoung.plantit.plantitbe.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class AdminAuthInterceptor implements HandlerInterceptor {
    public static final String ADMIN_LOGIN_SESSION_KEY = "ADMIN_LOGGED_IN";

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String uri = request.getRequestURI();
        if (uri.equals("/admin/login") || uri.equals("/admin/logout")) {
            return true;
        }

        HttpSession session = request.getSession(false);
        if (session != null && Boolean.TRUE.equals(session.getAttribute(ADMIN_LOGIN_SESSION_KEY))) {
            return true;
        }

        response.sendRedirect("/admin/login");
        return false;
    }
}
