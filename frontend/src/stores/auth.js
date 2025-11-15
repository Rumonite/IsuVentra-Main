// src/stores/auth.js
import { defineStore } from 'pinia';
import api from "@/services/api";

export const useAuthStore = defineStore('auth', {
    state: () => ({
        token: localStorage.getItem('token') || null,
        user: JSON.parse(localStorage.getItem('user') || 'null'),
        role: null, // either 'admin' or 'user'
    }),
    getters: {
        isLoggedIn: (state) => !!state.token,
        isAdmin: (state) => state.role === 'admin',
        isUser: (state) => state.role === 'user',
    },
    actions: {
        setAuth(user, token) {
            this.user = user;
            this.token = token;

            // Set role based on user info
            if (user?.is_admin === 1 || user?.is_admin === true) this.role = 'admin';
            else this.role = 'user';

            localStorage.setItem('user', JSON.stringify(user));
            localStorage.setItem('token', token);
        },
        async login(email, password) {
            const res = await api.post('/login', { email, password });
            const token = res.data.access_token ?? res.data.token ?? null;
            const user = res.data.user ?? res.data;

            if (!token) throw new Error('No token returned from login');
            this.setAuth(user, token);
            return { user, token };
        },
        logout() {
            this.user = null;
            this.token = null;
            this.role = null;
            localStorage.removeItem('user');
            localStorage.removeItem('token');
        }
    }
});
