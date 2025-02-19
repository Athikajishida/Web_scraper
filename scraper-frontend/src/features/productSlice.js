import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';
import axios from 'axios';

const api = axios.create({
  baseURL: 'http://localhost:3000/api/v1',
  headers: {
    'Content-Type': 'application/json',
  },
});


export const fetchProducts = createAsyncThunk(
    'products/fetchProducts',
    async (params = {}) => {
      const query = params.query || '';
      const response = await api.get(`/products?query=${query}`);
      return response.data.products;
    }
  );
  
export const scrapeProduct = createAsyncThunk(
  'products/scrapeProduct',
  async (url) => {
    const response = await api.post('/products', { url });
    return response.data;
  }
);

const productSlice = createSlice({
  name: 'products',
  initialState: {
    items: [],
    status: 'idle',
    error: null,
    searchQuery: '',
  },
  reducers: {
    setSearchQuery: (state, action) => {
      state.searchQuery = action.payload;
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(fetchProducts.pending, (state) => {
        state.status = 'loading';
      })
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