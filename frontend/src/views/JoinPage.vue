<template>
  <div class="join-container">
    <h2>Scan QR Code</h2>

    <video ref="video" autoplay muted playsinline></video>

    <div class="status">
      <p v-if="qrDetected"><strong>QR Code Detected!</strong></p>
      <p v-else>Point the camera at a QR code.</p>
    </div>

    <div class="scanned" v-if="scannedEventId">
      <p><strong>Scanned Event ID:</strong> {{ scannedEventId }}</p>
    </div>

    <div v-if="loading" class="loading">Processing…</div>

    <div v-if="error" class="error">{{ error }}</div>
  </div>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from "vue";
import { BrowserQRCodeReader } from "@zxing/browser";
import api from "@/services/api";

const video = ref(null);
const scannedEventId = ref(null);
const qrDetected = ref(false);
const loading = ref(false);
const error = ref(null);
const lastScanned = ref(null);

let codeReader = null;


onMounted(() => {
  codeReader = new BrowserQRCodeReader();
  codeReader.decodeFromVideoDevice(null, video.value, (result, err) => {
    if (result) {
      qrDetected.value = true;
      const eventId = result.getText().trim();
      if (lastScanned.value === eventId) return;
      lastScanned.value = eventId;
      handleScan(eventId);
    } else {
      qrDetected.value = false;
    }

    if (err && err.name !== "NotFoundException") console.warn(err);
  }).catch(err => {
    if (err.name === "NotAllowedError") error.value = "Camera access denied.";
    else if (err.name === "NotFoundError") error.value = "No camera found.";
    else error.value = "Camera initialization failed.";
  });
});


onBeforeUnmount(() => {
  if (codeReader && typeof codeReader.reset === "function") {
    codeReader.reset();  // this stops the camera
  } else if (video.value && video.value.srcObject) {
    // fallback for older ZXing versions: stop tracks manually
    const stream = video.value.srcObject;
    stream.getTracks().forEach(track => track.stop());
    video.value.srcObject = null;
  }
});


const handleScan = async (eventId) => {
  scannedEventId.value = eventId;
  loading.value = true;
  error.value = null;

  try {
    const res = await api.post("/participations/scan", { event_id: eventId });

    if (res.data.status === "already_in") {
      const confirmOut = confirm("You're already participating. Time-out now?");
      if (confirmOut) {
        await api.post("/participations/out", { event_id: eventId });
        alert("You have timed out.");
      } else {
        alert("You stayed checked-in.");
      }
    } else {
      alert("Participation recorded!");
    }
  } catch (err) {
    if (err.response) {
      error.value = err.response.data.message || "Server error.";
    } else {
      error.value = "Network error. Check your connection.";
    }
  } finally {
    loading.value = false;
    setTimeout(() => (lastScanned.value = null), 2000);
    setTimeout(() => (scannedEventId.value = null), 3000);
  }
};
</script>

<style scoped>
.join-container {
  max-width: 600px;
  margin: 40px auto;
  text-align: center;
  background-color: var(--secondary-bg);
  padding: 32px;
  border-radius: 16px;
  border: 1px solid var(--border-color);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12);
}

.join-container h2 {
  color: var(--text-color);
  margin-bottom: 20px;
}

video {
  width: 100%;
  max-width: 400px;
  border-radius: 6px;
  margin-bottom: 15px;
  border: 2px solid var(--border-color);
}

.status {
  margin-top: 10px;
  padding: 10px;
  background: var(--primary-bg);
  border-radius: 6px;
  border: 1px solid var(--border-color);
  color: var(--text-color);
}

.status p {
  margin: 0;
  font-weight: bold;
}

.scanned {
  margin-top: 10px;
  padding: 10px;
  background: rgba(102, 187, 106, 0.1);
  border-radius: 6px;
  border: 1px solid var(--accent);
  color: var(--text-color);
}

.scanned p {
  margin: 0;
  font-weight: bold;
}

.loading {
  margin-top: 10px;
  color: var(--text-color);
  font-weight: bold;
}

.error {
  margin-top: 10px;
  color: var(--error-color);
  background-color: rgba(255, 138, 128, 0.1);
  padding: 8px;
  border-radius: 4px;
  border: 1px solid var(--error-color);
}
</style>
