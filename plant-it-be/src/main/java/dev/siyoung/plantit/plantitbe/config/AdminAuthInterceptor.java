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
        boolean isAdmin = session != null && Boolean.TRUE.equals(session.getAttribute(ADMIN_LOGIN_SESSION_KEY));

        if (isAdmin) {
            return true;
        }

        if (uri.startsWith("/admin/swagger-ui") || uri.startsWith("/admin/api-docs")) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\":false,\"message\":\"Admin access required\"}");
            return false;
        }

        // Allow API calls from admin pages ONLY if logged in as admin
        if (uri.startsWith("/api/")) {
            if (isAdmin) {
                return true;
            }
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\":false,\"message\":\"Admin session required\"}");
            return false;
        }

        response.sendRedirect("/admin/login");
        return false;
    }
}
