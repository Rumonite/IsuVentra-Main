<template>
  <div>
    <h1>Events</h1>

    <button @click="$router.push('/join')">Join Event (Scan QR)</button>

    <div v-if="loading">Loading events...</div>

    <ul v-if="events.length">
      <li v-for="e in events" :key="e.id">
        <strong>{{ e.name }}</strong><br>
        <span>{{ e.description }}</span>
      </li>
    </ul>

    <p v-if="!loading && events.length === 0">No events available.</p>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import api from "@/services/api";

const events = ref([]);
const loading = ref(true);

async function fetchEvents() {
  try {
    const res = await api.get("/events"); // backend route
    events.value = res.data.events ?? res.data;
  } catch (err) {
    console.error("Error fetching events:", err);
  } finally {
    loading.value = false;
  }
}

onMounted(() => {
  fetchEvents();
});
</script>

<style scoped>
h1 {
  color: var(--text-color);
  margin-bottom: 24px;
  font-size: 2em;
  font-weight: 300;
  text-align: center;
}

button {
  padding: 14px 24px;
  background-color: var(--accent);
  color: var(--primary-bg);
  border: none;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  margin-bottom: 32px;
  transition: all 0.3s ease;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  display: block;
  margin-left: auto;
  margin-right: auto;
}

button:hover {
  background-color: var(--light-accent);
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
}

ul {
  list-style: none;
  padding: 0;
  max-width: 800px;
  margin: 0 auto;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
}

li {
  background-color: var(--secondary-bg);
  margin-bottom: 0;
  padding: 20px;
  border-radius: 12px;
  border: 1px solid var(--border-color);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

li:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
}

li strong {
  color: var(--accent);
  display: block;
  margin-bottom: 8px;
  font-size: 1.1em;
  font-weight: 600;
}

li span {
  color: var(--text-color);
  line-height: 1.5;
}

.loading, .no-events {
  color: var(--text-color);
  font-size: 18px;
  text-align: center;
  margin-top: 60px;
  font-weight: 300;
}
</style>
