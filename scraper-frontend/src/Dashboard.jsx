import React, { useEffect, useState, useCallback } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Search } from 'lucide-react';
import { fetchProducts, scrapeProduct, setSearchQuery } from './features/productSlice';
import _ from 'lodash';

const Dashboard = () => {
    const dispatch = useDispatch();
    const { items = [], status, error, searchQuery } = useSelector((state) => state.products);
    const [url, setUrl] = useState('');
    const [errorMessage, setErrorMessage] = useState('');

    useEffect(() => {
        if (status === 'idle') {
            dispatch(fetchProducts());
        }
    }, [status, dispatch]);

    const validateUrl = (inputUrl) => {
        const urlPattern = /^(https?:\/\/)?([\w\-]+\.)+[\w]{2,}(\/.*)?$/;
        return urlPattern.test(inputUrl);
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        if (!validateUrl(url)) {
            setErrorMessage('Please enter a valid URL');
            return;
        }
        setErrorMessage('');
        await dispatch(scrapeProduct(url));
        setUrl('');
    };

    const debouncedSearch = useCallback(
        _.debounce((value) => {
            dispatch(setSearchQuery(value));
            dispatch(fetchProducts({ query: value }));
        }, 300),
        [dispatch]
    );

    const handleSearchChange = (e) => {
        debouncedSearch(e.target.value);
    };

    const filteredProducts = Array.isArray(items) 
        ? items.filter((product) =>
            product?.title?.toLowerCase().includes(searchQuery.toLowerCase()) ||
            product?.description?.toLowerCase().includes(searchQuery.toLowerCase())
        )
        : [];

    const isLoading = status === 'loading';

    return (
        <div className="min-h-screen bg-white">
            {/* Header */}
            <header className="bg-[#4BB7D4] text-white">
                <div className="max-w-7xl mx-auto px-6 py-8">
                    <h1 className="text-4xl font-normal">Flipkart Scraper</h1>
                </div>
            </header>

            {/* Main Content */}
            <main className="max-w-7xl mx-auto px-6 py-8">
                {/* URL Input Section */}
                <div className="mb-8">
                    {/* <h2 className="text-xl text-gray-900 mb-4">Enter Flipkart URL here..</h2> */}
                    <form onSubmit={handleSubmit} className="flex gap-4">
                        <input
                            type="text"
                            placeholder="Enter product URL to scrape..."
                            className="flex-1 p-3 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#4BB7D4] focus:border-transparent"
                            value={url}
                            onChange={(e) => setUrl(e.target.value)}
                            disabled={isLoading}
                        />
                        <button type="submit" className="px-4 py-3 bg-[#4BB7D4] text-white rounded-lg hover:bg-[#3aa6bf]">
                            Scrape
                        </button>
                    </form>
                    {errorMessage && <p className="text-red-600 mt-2">{errorMessage}</p>}
                    {error && <p className="text-red-600 mt-2">{error}</p>}
                </div>

                {/* Search Section */}
                <div className="mb-8 flex gap-4 items-center">
                    <div className="flex-1 relative">
                        <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
                        <input
                            type="text"
                            placeholder="Search products..."
                            className="w-full pl-10 p-3 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#4BB7D4] focus:border-transparent"
                            onChange={handleSearchChange}
                        />
                    </div>
                    <button className="px-4 py-3 border border-gray-200 rounded-lg text-gray-600 hover:bg-gray-50">
                        Filters
                    </button>
                </div>

                {/* Products Grid */}
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    {filteredProducts.map((product) => (
                        <div key={product.id} className="border border-gray-200 rounded-lg overflow-hidden">
                            <img
                                src={product.image_url || '/api/placeholder/200/200'}
                                alt={product.title}
                                className="w-full h-48 object-cover"
                            />
                            <div className="p-4">
                                <div className="flex justify-between items-start mb-2">
                                    <h3 className="text-lg font-semibold text-gray-900">{product.title}</h3>
                                    <span className="text-[#4BB7D4] font-bold">
                                        {product.currency} {product.price}
                                    </span>
                                </div>
                                <p className="text-gray-600 text-sm">{product.description}</p>
                            </div>
                        </div>
                    ))}
                </div>
            </main>
        </div>
    );
};

export default Dashboard;
