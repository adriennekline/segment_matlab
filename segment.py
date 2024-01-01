import os
import cv2
import numpy as np
from matplotlib import pyplot as plt
from matplotlib.widgets import Cursor

def select_roi(image):
    """ 
    Function to allow user to draw freehand ROI on the image.
    Returns the mask of the drawn ROI.
    """
    # This function needs to be implemented based on user interaction requirements.
    # OpenCV or matplotlib can be used to draw and capture the ROI.
    # Currently, it returns a placeholder.
    return np.zeros(image.shape[:2], dtype="uint8")

# Set the directory path where the PNG images are located
directory = '/Users/.....'

# Get a list of all files in the directory
files = [f for f in os.listdir(directory) if f.endswith('.jpeg')]

# Loop through each file in the directory
for filename in files:
    filepath = os.path.join(directory, filename)
    img = cv2.imread(filepath)

    # Display the image
    plt.imshow(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))
    plt.title('Current Image')
    plt.show(block=False)

    # Get user input for the number of structures to segment
    num_ROIs = int(input("How many structures do you wish to segment in the image? "))

    # Initialize an empty list for ROI masks
    ROI_masks = []

    for _ in range(num_ROIs):
        # User selects ROI on the image
        ROI_mask = select_roi(img)
        ROI_masks.append(ROI_mask)

        # Wait for user input before moving on
        input("Press Enter to continue after drawing ROI...")

    # Initialize the combined mask with zeros
    combined_mask = np.zeros(img.shape[:2], dtype="uint8")

    # Combine the masks using logical OR operation
    for mask in ROI_masks:
        combined_mask = np.bitwise_or(combined_mask, mask)

    # Create name for saving the mask
    file_save_name, _ = os.path.splitext(filename)
    filename_mask = os.path.join(directory, f"{file_save_name}_combined_mask.png")

    # Save the combined mask as an image
    cv2.imwrite(filename_mask, combined_mask)

    # Close all figures
    plt.close('all')
