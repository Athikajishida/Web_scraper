/**
 * @file productSlice.js
 * @description Redux slice for managing product state, including fetching and scraping products
 * @version 1.0.0
 * @author Athika jishida
 */
import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import axios from 'axios';

// Create axios instance with default configuration
const api = axios.create({
  baseURL: 'http://localhost:3000/api/v1',
  headers: {
    'Content-Type': 'application/json',
  },
});

/**
 * Async thunk to fetch products from the API
 * @param {Object} params - Query parameters
 * @param {string} [params.query=''] - Search query string
 * @returns {Promise<Array>} Array of product objects
 * @throws {Error} When API request fails
 */
export const fetchProducts = createAsyncThunk(
    'products/fetchProducts',
    async (params = {}) => {
      const query = params.query || '';
      const response = await api.get(`/products?query=${query}`);
      return response.data.products;
    }
  );
  
/**
 * Async thunk to scrape product information from a URL
 * @param {string} url - URL of the product to scrape
 * @returns {Promise<Object>} Scraped product data
 * @throws {Error} When scraping fails or API request fails
 */
export const scrapeProduct = createAsyncThunk(
  'products/scrapeProduct',
  async (url) => {
    const response = await api.post('/products', { url });
    return response.data;
  }
);

/**
 * Redux slice for products state management
 * @typedef {Object} ProductState
 * @property {Array} items - Array of product objects
 * @property {'idle' | 'loading' | 'succeeded' | 'failed'} status - Current API request status
 * @property {string|null} error - Error message if request failed
 * @property {string} searchQuery - Current search query
 */
const productSlice = createSlice({
  name: 'products',
  initialState: {
    items: [],
    status: 'idle',
    error: null,
    searchQuery: '',
  },

  /**
     * Updates the search query in the state
     * @param {ProductState} state - Current state
     * @param {Object} action - Redux action object
     * @param {string} action.payload - New search query
     */
  reducers: {
    setSearchQuery: (state, action) => {
      state.searchQuery = action.payload;
    },
  },
  extraReducers: (builder) => {
    builder
      // Handle fetchProducts states
      .addCase(fetchProducts.pending, (state) => {
        state.status = 'loading';
      })
    // Ensure payload is always treated as an array
      .addCase(fetchProducts.fulfilled, (state, action) => {
        state.status = 'succeeded';
        state.items = Array.isArray(action.payload) ? action.payload : [];
      })
      .addCase(fetchProducts.rejected, (state, action) => {
        state.status = 'failed';
        state.error = action.error.message;
      })
      .addCase(scrapeProduct.pending, (state) => {
        state.status = 'loading';
      })
      .addCase(scrapeProduct.fulfilled, (state, action) => {
        state.status = 'succeeded';
        // Safely update items array
        state.items = Array.isArray(state.items) 
          ? [...state.items, action.payload]
          : [action.payload];
      })
      .addCase(scrapeProduct.rejected, (state, action) => {
        state.status = 'failed';
        state.error = action.error.message;
      });
  },
});

export const { setSearchQuery } = productSlice.actions;
export default productSlice.reducer;