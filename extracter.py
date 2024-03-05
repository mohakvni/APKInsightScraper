import json

# Load the JSON data from the file
with open('./results/resultTemp.json', 'r') as file:
    apps_data = json.load(file)

# Define keywords to search for in permissions
network_keywords = ['network', 'internet']
bluetooth_keywords = ['bluetooth']

# Filter apps that have network or bluetooth related permissions
# filtered_apps = []
# for app in apps_data:
#     for permission in app['permissions']:
#         # Check if permission is related to network or bluetooth
#         if any(keyword in permission['permission'].lower() for keyword in network_keywords + bluetooth_keywords):
#             filtered_apps.append(app["name"])
#             break  # No need to check remaining permissions for this app

filtered_apps = []
for app in apps_data:
    filtered_apps.append(app["name"])

# Optionally, save the filtered apps to a new JSON file
with open('filtered_result.json', 'w') as outfile:
    json.dump(filtered_apps, outfile, indent=4)
