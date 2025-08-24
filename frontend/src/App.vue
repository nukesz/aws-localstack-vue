<script setup>
import { ref, onMounted } from "vue"
import axios from "axios"

const news = ref([])

onMounted(async () => {
  const apiUrl = import.meta.env.VITE_API_URL
  const res = await axios.get(apiUrl)
  news.value = res.data
})
</script>

<template>
   <div class="p-4">
    <h1>Top 10 News</h1>
    <ul>
      <li v-for="item in news" :key="item.id">
        <strong>{{ item.title }}</strong> - {{ item.description }}
      </li>
    </ul>
  </div>
</template>

<style scoped>
</style>
