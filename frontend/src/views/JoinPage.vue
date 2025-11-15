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

const showScanner = ref(true);
const video = ref(null);
const scannedEventId = ref(null);
const qrDetected = ref(false);
const loading = ref(false);
const error = ref(null);
const lastScanned = ref(null);

let codeReader;

onMounted(async () => {
  codeReader = new BrowserQRCodeReader();

  try {
    await codeReader.decodeFromVideoDevice(null, video.value, (result, err) => {
      if (result) {
        qrDetected.value = true;

        const eventId = result.getText().trim();

        // Prevent duplicate scans
        if (lastScanned.value === eventId) return;
        lastScanned.value = eventId;

        handleScan(eventId);
      } else {
        qrDetected.value = false;
      }

      if (err && !(err.name === "NotFoundException")) {
        console.warn(err);
      }
    });
  } catch (err) {
    if (err.name === "NotAllowedError") error.value = "Camera access denied.";
    else if (err.name === "NotFoundError") error.value = "No camera found.";
    else error.value = "Camera initialization failed.";
  }
});

onBeforeUnmount(() => {
  // just hide/unmount the scanner instead of calling reset()
  showScanner.value = false;
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
  max-width: 500px;
  margin: 20px auto;
  text-align: center;
}

video {
  width: 100%;
  max-width: 400px;
  border-radius: 6px;
  margin-bottom: 15px;
}

.status {
  margin-top: 10px;
  padding: 10px;
  background: #eef;
  border-radius: 6px;
}

.scanned {
  margin-top: 10px;
  padding: 10px;
  background: #def;
  border-radius: 6px;
}

.loading {
  margin-top: 10px;
  color: #333;
}

.error {
  margin-top: 10px;
  color: red;
}
</style>
