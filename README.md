# AgriLink: Buy, Sell, & Diagnose Crop Diseases

AgriLink is an Android app designed to empower farmers with a marketplace for buying and selling crops directly and an AI-driven crop disease detection tool. By capturing an image of a crop's leaf, farmers can quickly diagnose diseases. The marketplace feature enables farmers to connect directly with potential buyers, reducing reliance on intermediaries.
## Table of Contents

    Project Overview
    Features
    Technologies Used
    Screenshots
    Architecture
    Dataset
    Installation
    Usage
    Future Improvements
    License

## Project Overview

AgriLink is designed to support farmers by combining an online marketplace for crop trading with an AI-powered crop disease detection feature. This platform bridges information and accessibility gaps, enabling farmers to market their products, directly connect with buyers, and manage crop health more effectively.
Features

    Marketplace: Buy and sell crops directly with other users. Each listing includes photos, descriptions, and pricing.
    AI-Powered Crop Disease Detection: Capture or upload images of crops to detect diseases, providing an instant diagnosis to assist in early treatment.
    User-Friendly Interface: Simple and intuitive design, suitable for users with varying literacy levels.
    Multilingual Support: Available in regional languages to improve accessibility.

## Technologies Used

    Android (Java/Kotlin): For building the mobile application.
    Firebase: For user authentication and real-time database management.
    TensorFlow Lite: For running the AI model on mobile devices.
    OpenCV: For image preprocessing and enhancement.

## Screenshots

(Add screenshots of AgriLink’s interface, marketplace, and disease detection results)
Architecture

## AgriLink follows an MVC (Model-View-Controller) architecture and includes the following key modules:

    Marketplace Module:
        Allows users to list, browse, and search for crops, with details on each item for sale.
        Firebase handles listings, storage, and updates.

    Disease Detection Module:
        A Convolutional Neural Network (CNN) model processes images using TensorFlow Lite.
        Preprocessed images are fed into the model, providing immediate feedback on potential diseases.

    Backend Services:
        Firebase Authentication for user management.
        Firebase Realtime Database for managing listings, profiles, and transactions.

## Dataset

The disease detection model is trained on a labeled dataset of crop images, such as the PlantVillage Dataset. The dataset includes various crop types and disease labels, essential for accurate predictions.

The dataset structure:

data/
  ├── train/
  │   ├── healthy/
  │   ├── disease_1/
  │   ├── disease_2/
  ├── test/
  │   ├── healthy/
  │   ├── disease_1/
  │   ├── disease_2/

## Installation

    Clone this repository:

git clone https://github.com/yourusername/agrilink.git
cd agrilink


## Usage

    Marketplace:
        Open AgriLink, sign in, and explore the Marketplace tab.
        View and post crop listings to buy or sell products.

    Disease Detection:
        Navigate to the "Disease Detection" tab.
        Capture or upload an image of a crop leaf.
        The app will analyze the image and display the diagnosis with treatment suggestions.

## Future Improvements

    Enhanced Model Accuracy: Increase accuracy by expanding training data and refining the CNN model.
    Offline Mode: Enable offline disease detection for farmers with limited internet.
    Push Notifications: Notify users of new listings, price changes, and agricultural news.
    Weather Integration: Provide insights based on local weather and crop conditions.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
