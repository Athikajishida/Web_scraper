/**
 * @file App.jsx
 * @description Root component of the application that sets up Redux store provider
 * @version 1.0.0
 * @author Athika Jishida
 */

import { Provider } from 'react-redux';
import { store } from './app/store';
import Dashboard from './Dashboard';

function App() {
  /**
 * Root Application Component
 * Wraps the entire application with Redux Provider and renders the main Dashboard
 * 
 * The Provider component makes the Redux store available to any nested components
 * that need to access the Redux store.
 * 
 * @component
 * @returns {JSX.Element} The rendered App component
 */
  return (
    <Provider store={store}>
        <Dashboard />
    </Provider>
  );
}

export default App;