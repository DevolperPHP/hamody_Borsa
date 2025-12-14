#!/bin/bash

echo "================================"
echo "🧪 Testing Gold Price Backend"
echo "================================"
echo ""

# Test 1: Health Check
echo "1️⃣  Testing Health Check..."
response=$(curl -s http://localhost:3000/health)
echo "Response: $response"
echo ""

# Test 2: Get Gold Price
echo "2️⃣  Testing Gold Price Endpoint..."
response=$(curl -s http://localhost:3000/api/gold-price)
echo "Response: $response"
echo ""

# Test 3: Get Status
echo "3️⃣  Testing Status Endpoint..."
response=$(curl -s http://localhost:3000/api/status)
echo "Response: $response"
echo ""

echo "================================"
echo "✅ All tests completed!"
echo "================================"
