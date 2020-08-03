# Campaign Manager & DV360 Block

<br>

### Why use the Looker Campaign Manager Block?
**(1) Rapid Time To Value** - gain insights from your CM data in minutes, not weeks. The Campaign Manager Block includes pre-built dashboards and content focusing on the ad management system for advertisers and agencies, with analysis around campaign performance, reach and impressions. Additionally, dashboards have been developed to answer the most asked questions around Campaign Manager.

**(2) Centralized Place for Analysis** -  No Campaign Manager access required to do self-service reporting. Plus, you can combine your Campaign Manager data with other data in your warehouse (e.g. Bitbucket or Github commits) for end-to-end analysis.

**(3) Enterprise Data Platform** - Your marketing team can easily build their own dashboards, and any user is equipped to ask and answer their own questions, save and share their own reports. Additionally, you can take advantage of Looker's advanced scheduling functionality to get Alerts whenever workflows are disrupted. Using our Data Health Check dashboard within the block you can monitor redacted User IDs within Campaign Manager.

<br>

### Campaign Manager Data Structure and Schema

Campaign Manager data is exported through [Transfer Services](https://cloud.google.com/bigquery-transfer/docs/doubleclick-campaign-transfer) in the format of three flat tables (a single file for impressions, clicks, and activities). All Data Transfer Files are stored as comma separated values (CSV).

Filenames are a combination of dcm ID (like account, or floodlight), data transfer type (impression, click, activity, or rich_media), the date and hour of the processed file (YYYYMMDDHH), the day the report was generated (YYYYMMDD), the time the report was generated (HHMMSS), and the execution ID of the report separated by underscores. A more detailed description of the Data Transfer customisation and fields can be found [here](https://developers.google.com/doubleclick-advertisers/dtv2/reference/file-format).

It is strongly recommended that you load all match tables into your warehouse to allow your business users to gain a deeper understanding into the naming conventions of your campaigns, activities, ads, advertisers, assets, and browsers. More information on all Data Transfer match tables can also be found [here](https://developers.google.com/doubleclick-advertisers/dtv2/reference/match-tables).

<br>

### Campaign Manager Block Structure

Insert overview of block structure here.

<br>

### Customizations

Insert overview of customizations here.

<br>

### What if I find an error? Suggestions for improvements?

Great! Blocks were designed for continuous improvement through the help of the entire Looker community and we'd love your input. To report an error or improvement recommendation, please reach out to Looker support via email to support@looker.com or via chat to submit a request. Please be as detailed as possible in your explanation and we'll address it as quick as we can.
