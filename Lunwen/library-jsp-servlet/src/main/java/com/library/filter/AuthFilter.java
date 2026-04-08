package com.library.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        String uri = req.getRequestURI();
        String context = req.getContextPath();
        String path = uri.substring(context.length());

        if (isPublic(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        Integer role = session == null ? null : (Integer) session.getAttribute("role");
        if (role == null) {
            resp.sendRedirect(context + "/login.jsp");
            return;
        }

        if (path.startsWith("/admin") && role != 1) {
            resp.sendRedirect(context + "/books?error=无管理员权限");
            return;
        }
        if (path.startsWith("/reader") && role != 0) {
            resp.sendRedirect(context + "/books?error=无读者权限");
            return;
        }

        chain.doFilter(request, response);
    }

    private boolean isPublic(String path) {
        return path.equals("/")
                || path.equals("/login.jsp")
                || path.equals("/register.jsp")
                || path.equals("/login")
                || path.equals("/register")
                || path.startsWith("/assets/");
    }
}
