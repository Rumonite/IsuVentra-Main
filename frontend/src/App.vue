<template>
  <div id="app">
    <nav v-if="auth.isLoggedIn">
      <router-link to="/dashboard" v-if="auth.role === 'user'">Dashboard</router-link>
      <router-link to="/join" v-if="auth.role === 'user'">Join Event</router-link>
      <router-link to="/admin" v-if="auth.role === 'admin'">Admin Dashboard</router-link>
      <button @click="logout">Logout</button>
    </nav>
    <nav v-else>
      <router-link to="/">Login</router-link>
      <router-link to="/register">Register</router-link>
    </nav>

    <router-view />
  </div>
</template>

<script setup>
import { useAuthStore } from "@/stores/auth";
import { onMounted } from "vue";
import { useRouter } from "vue-router";
import api from "@/services/api";

const auth = useAuthStore();
const router = useRouter();

const logout = () => {
  auth.logout();
  router.push({ name: "login" });
};

onMounted(async () => {
  const auth = useAuthStore();
  if (auth.token) {
    try {
      const response = await api.get('/validate-token');
      // Update user data from server if needed
      if (response.data.user) {
        auth.setAuth(response.data.user, auth.token);
      }
    } catch {
      auth.logout();
    }
  }
});
</script>



<style>
:root {
  --primary-bg: #2d4a22;
  --secondary-bg: #4a6b3a;
  --accent: #66bb6a;
  --light-accent: #81c784;
  --text-color: #f1f8e9;
  --error-color: #ef5350;
  --success-color: #81c784;
  --border-color: #6b8e5a;
}

#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: var(--text-color);
  background-color: var(--primary-bg);
  min-height: 100vh;
}

nav {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 15px;
  padding: 15px;
  margin-bottom: 20px;
  background-color: var(--secondary-bg);
  border-bottom: 1px solid var(--border-color);
}

nav a {
  font-weight: bold;
  color: var(--text-color);
  text-decoration: none;
  position: relative;
  padding: 0 10px;
}

/* separator using pseudo-element */
nav a + a::before {
  content: "|";
  position: absolute;
  left: 0;
  color: var(--light-accent);
}

/* active route highlight */
nav a.router-link-exact-active {
  color: var(--accent);
}

nav button {
  cursor: pointer;
  font-weight: bold;
  background: var(--error-color);
  color: var(--primary-bg);
  border: none;
  padding: 5px 10px;
  border-radius: 3px;
}

nav button:hover {
  background: #e57373;
}
</style>
