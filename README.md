# Metadata Tracker

The Metadata Tracker allows you to track your metadata from within your Salesforce org, making it easier to manage what needs to be deployed during a project.

![metadata tracker screenshot](/content/img/metadata-tracker-screenshot.png)

## Installation

1. Ensure my domain is enabled (this is needed for any lightning components to render!)
2. Navigate to the latest release for a package installation link: [latest release](https://github.com/dmgerow/metadata-tracker/releases/latest)
3. Install for admins only
4. Assign the Metadata Tracker Permission Set to your team
5. Configure the custom settings if you want to do special things (only use org custom settings)

## Usage

The most up to date information in the help component can be found [here](https://docs.google.com/document/d/1Vo7t0vxxUo2qcHiKo7uifm5SY3G8Rd-u41MDNAuKKys/edit#)

### Tracking Metadata

1. Open the Metadata Tracker App
2. Select the metadata type you would like to add
3. Select the piece of metadata that you would like to add or remove from the tracker

### Generating Packages (for constructive and destructive changes)

1. Open the Metadata Tracker App
2. Click "Get Packages"
3. Specify if you want all tracked metadata, or only metadata tracked during a specified time range.
4. Download zip
5. Open zip to find the package and destructiveChanges files

### Reporting on Tracked Metadata

1. Open the Metadata Tracker Report Folder
2. Click a report or make your own

## Troubleshooting

Q: I cannot see the utility bar in the Metadata Tracker App, what is wrong?

A: Try adding the component to another app.

## Technical Setup Notes

This creates a scratch org, pushes the metadata, and assigns you the correct permission set.

```bash
npm run create:scratch
```
