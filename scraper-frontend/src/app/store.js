/**
 * @file store.js
 * @description Redux store configuration file that combines all reducers and sets up the global store
 * @version 1.0.0
 * @author Athika Jishida
 */

import { configureStore } from '@reduxjs/toolkit';
import productReducer from '../features/productSlice';

export const store = configureStore({
  reducer: {
    products: productReducer,
  },
});