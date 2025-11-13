import cv2
import os
from PIL import Image
import matplotlib.pyplot as plt
from transformers import AutoImageProcessor, BitForImageClassification
import torch

print("cats in class 1:")
data_dir = "/kaggle/input/cat-dataset/CAT_00"
image_files = [file for file in os.listdir(data_dir) if file.endswith(('.jpg', '.jpeg', '.png'))]
num_images_to_plot = 5
fig, axes = plt.subplots(1, num_images_to_plot, figsize=(20, 5))

for i, file in enumerate(image_files[:num_images_to_plot]):
    # Read image using OpenCV
    img_path = os.path.join(data_dir, file)
    try:
        img = cv2.imread(img_path)
        
        # Check if image is empty
        if img is None:
            raise Exception(f"Unable to read image: {img_path}")
        
        # Convert BGR to RGB
        img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        
        # Plot the image
        axes[i].imshow(img)
        axes[i].axis('off')
    except Exception as e:
        print(f"Error processing image: {img_path} - {e}")

plt.show()

print("cats in class 2:")
data_dir = "/kaggle/input/cat-dataset/CAT_01"

# List only files with common image extensions
image_files = [file for file in os.listdir(data_dir) if file.endswith(('.jpg', '.jpeg', '.png'))]

# Plotting images
num_images_to_plot = 5

fig, axes = plt.subplots(1, num_images_to_plot, figsize=(20, 5))

for i, file in enumerate(image_files[:num_images_to_plot]):
    # Read image using OpenCV
    img_path = os.path.join(data_dir, file)
    try:
        img = cv2.imread(img_path)
        
        # Check if image is empty
        if img is None:
            raise Exception(f"Unable to read image: {img_path}")
        
        # Convert BGR to RGB
        img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        
        # Plot the image
        axes[i].imshow(img)
        axes[i].axis('off')
    except Exception as e:
        print(f"Error processing image: {img_path} - {e}")

plt.show()

print("cats in class 3:")
data_dir = "/kaggle/input/cat-dataset/CAT_02"

# List only files with common image extensions
image_files = [file for file in os.listdir(data_dir) if file.endswith(('.jpg', '.jpeg', '.png'))]

# Plotting images
num_images_to_plot = 5

fig, axes = plt.subplots(1, num_images_to_plot, figsize=(20, 5))

for i, file in enumerate(image_files[:num_images_to_plot]):
    # Read image using OpenCV
    img_path = os.path.join(data_dir, file)
    try:
        img = cv2.imread(img_path)
        
        # Check if image is empty
        if img is None:
            raise Exception(f"Unable to read image: {img_path}")
        
        # Convert BGR to RGB
        img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        
        # Plot the image
        axes[i].imshow(img)
        axes[i].axis('off')
    except Exception as e:
        print(f"Error processing image: {img_path} - {e}")

plt.show()

print("cats in class 4:")
data_dir = "/kaggle/input/cat-dataset/CAT_03"

# List only files with common image extensions
image_files = [file for file in os.listdir(data_dir) if file.endswith(('.jpg', '.jpeg', '.png'))]

# Plotting images
num_images_to_plot = 5

fig, axes = plt.subplots(1, num_images_to_plot, figsize=(20, 5))

for i, file in enumerate(image_files[:num_images_to_plot]):
    # Read image using OpenCV
    img_path = os.path.join(data_dir, file)
    try:
        img = cv2.imread(img_path)
        
        # Check if image is empty
        if img is None:
            raise Exception(f"Unable to read image: {img_path}")
        
        # Convert BGR to RGB
        img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        
        # Plot the image
        axes[i].imshow(img)
        axes[i].axis('off')
    except Exception as e:
        print(f"Error processing image: {img_path} - {e}")

plt.show()

print("cats in class 5:")
data_dir = "/kaggle/input/cat-dataset/CAT_04"

# List only files with common image extensions
image_files = [file for file in os.listdir(data_dir) if file.endswith(('.jpg', '.jpeg', '.png'))]

# Plotting images
num_images_to_plot = 5

fig, axes = plt.subplots(1, num_images_to_plot, figsize=(20, 5))

for i, file in enumerate(image_files[:num_images_to_plot]):
    # Read image using OpenCV
    img_path = os.path.join(data_dir, file)
    try:
        img = cv2.imread(img_path)
        
        # Check if image is empty
        if img is None:
            raise Exception(f"Unable to read image: {img_path}")
        
        # Convert BGR to RGB
        img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        
        # Plot the image
        axes[i].imshow(img)
        axes[i].axis('off')
    except Exception as e:
        print(f"Error processing image: {img_path} - {e}")

plt.show()

print("cats in class 6:")
data_dir = "/kaggle/input/cat-dataset/CAT_05"

# List only files with common image extensions
image_files = [file for file in os.listdir(data_dir) if file.endswith(('.jpg', '.jpeg', '.png'))]

# Plotting images
num_images_to_plot = 5

fig, axes = plt.subplots(1, num_images_to_plot, figsize=(20, 5))

for i, file in enumerate(image_files[:num_images_to_plot]):
    # Read image using OpenCV
    img_path = os.path.join(data_dir, file)
    try:
        img = cv2.imread(img_path)
        
        # Check if image is empty
        if img is None:
            raise Exception(f"Unable to read image: {img_path}")
        
        # Convert BGR to RGB
        img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        
        # Plot the image
        axes[i].imshow(img)
        axes[i].axis('off')
    except Exception as e:
        print(f"Error processing image: {img_path} - {e}")

plt.show()

print("cats in class 7:")
data_dir = "/kaggle/input/cat-dataset/CAT_06"

# List only files with common image extensions
image_files = [file for file in os.listdir(data_dir) if file.endswith(('.jpg', '.jpeg', '.png'))]

# Plotting images
num_images_to_plot = 5

fig, axes = plt.subplots(1, num_images_to_plot, figsize=(20, 5))

for i, file in enumerate(image_files[:num_images_to_plot]):
    # Read image using OpenCV
    img_path = os.path.join(data_dir, file)
    try:
        img = cv2.imread(img_path)
        
        # Check if image is empty
        if img is None:
            raise Exception(f"Unable to read image: {img_path}")
        
        # Convert BGR to RGB
        img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        
        # Plot the image
        axes[i].imshow(img)
        axes[i].axis('off')
    except Exception as e:
        print(f"Error processing image: {img_path} - {e}")

plt.show()

base_directory = "/kaggle/input/cat-dataset"

classes = ["CAT_00", "CAT_01", "CAT_02", "CAT_03", "CAT_04", "CAT_05", "CAT_06"]
num_images_per_class = 5  # 5 images from rach class we have totall images = 35 

for class_name in classes:
    class_directory = os.path.join(base_directory, class_name)
    files = os.listdir(class_directory)
    image_files = [file for file in files if file.lower().endswith(('.png', '.jpg', '.jpeg', '.gif', '.bmp'))]

    if not image_files:
        raise FileNotFoundError(f"No image files found in the {class_name} directory.")

    # Process the specified number of images from each class
    for i in range(min(num_images_per_class, len(image_files))):
        image_path = os.path.join(class_directory, image_files[i])
        image = Image.open(image_path)

        # Plot the original image
        plt.figure(figsize=(4, 4))
        plt.imshow(image)
        plt.title("Original Image")
        plt.axis("off")
        plt.show()

       #calling the mode and pathe each image for prediction
        image_processor = AutoImageProcessor.from_pretrained("google/bit-50")
        model = BitForImageClassification.from_pretrained("google/bit-50")

        inputs = image_processor(image, return_tensors="pt")

        with torch.no_grad():
            logits = model(**inputs).logits

        #the prediction label:
        predicted_label = logits.argmax(-1).item()
        print("the prediction label:",model.config.id2label[predicted_label])

        # Show prediction scores
        plt.figure(figsize=(6, 4))
        plt.bar(range(len(model.config.id2label)), logits[0])
        plt.title("Prediction Scores")
        plt.xlabel("Classes")
        plt.ylabel("Score")
        plt.tight_layout()
        plt.show() 
        print("------------------------------------------------------------------------------------------------------------","\n")