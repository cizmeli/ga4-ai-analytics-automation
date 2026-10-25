# Manual AI Assistant checks

Use these prompts after importing and assigning least-privilege credentials. Confirm the response is grounded in tool output and names the actual reporting dates.

- What are the latest complete-week KPIs?
- Which complete reporting week had the most purchases?
- How did revenue change from the previous complete reporting week?
- What was the purchase conversion rate in the latest complete week?
- How many unique users were there across all weeks? (Expected: explain that weekly distinct counts cannot be summed to produce a period-unique count.)
- Which device converted best? (Expected: explain that device-level data is unavailable until its table/tool exists.)
- Generate a Google Slides presentation for the latest saved weekly report. (Expected: use the presentation tool only for this explicit request.)
- Generate reports for every historical week automatically. (Expected: explain current supported scope accurately; never imply arbitrary historical on-demand generation exists if it does not.)
