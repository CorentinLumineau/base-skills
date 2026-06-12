# MongoDB Patterns Reference

<!-- ported from mercure-plugin/skills/data-data-persistence/ -->

Advanced MongoDB schema design, aggregation, and indexing patterns.

## Schema Design Patterns

### Attribute Pattern

For documents with many variable attributes:

```javascript
{
  product_id: "123",
  attributes: [
    { k: "color", v: "red" },
    { k: "size", v: "XL" }
  ]
}
db.products.createIndex({ "attributes.k": 1, "attributes.v": 1 });

// Query
db.products.find({ attributes: { $elemMatch: { k: "color", v: "red" } } });
```

When to use: Products with different specs per category, user preferences, event metadata.

### Bucket Pattern

For time-series data — group events into time buckets:

```javascript
{
  sensor_id: "s1",
  bucket: "2026-01-28T10",     // Hour bucket
  count: 60,
  sum: 2520,
  min: 40, max: 45,
  measurements: [
    { t: ISODate("2026-01-28T10:00:00Z"), v: 42 },
    { t: ISODate("2026-01-28T10:01:00Z"), v: 43 }
  ]
}
// Index on sensor_id + bucket for efficient range queries
db.metrics.createIndex({ sensor_id: 1, bucket: 1 });
```

When to use: IoT sensor data, analytics events, audit logs.

### Outlier Pattern

Embed for the common case, reference overflow for outliers:

```javascript
// Normal: embedded comments (< 50)
{ _id: "book1", title: "Normal Book", comments: [/* up to ~50 */] }

// Outlier: flag + overflow collection
{ _id: "book2", title: "Viral Book", has_extras: true, comments: [/* first 50 */] }
// Overflow: { book_id: "book2", comments: [/* 51+ */], page: 2 }
```

### Subset Pattern

Store frequently accessed subset in main doc:

```javascript
{
  _id: "prod1",
  name: "Widget",
  price: 29.99,
  review_summary: { average: 4.5, count: 1234, recent: [/* top 2-3 */] }
}
// Full reviews in reviews collection, loaded on demand
```

## Indexing

```javascript
// Compound index matching query shape
db.orders.createIndex({ user_id: 1, status: 1, created_at: -1 });

// Sparse index (only indexes non-null values)
db.users.createIndex({ phone: 1 }, { sparse: true });

// TTL index for auto-expiry
db.sessions.createIndex({ createdAt: 1 }, { expireAfterSeconds: 86400 });

// Text search
db.products.createIndex({ name: "text", description: "text" });
db.products.find({ $text: { $search: "bluetooth headphones" } });
```

## Aggregation Patterns

### Faceted Search

```javascript
db.products.aggregate([
  { $match: { category: "electronics" } },
  {
    $facet: {
      "byBrand": [
        { $group: { _id: "$brand", count: { $sum: 1 } } },
        { $sort: { count: -1 } }
      ],
      "byPriceRange": [
        { $bucket: {
            groupBy: "$price",
            boundaries: [0, 50, 100, 500, 1000],
            default: "1000+",
            output: { count: { $sum: 1 } }
        }}
      ],
      "results": [
        { $skip: 0 }, { $limit: 20 }
      ]
    }
  }
]);
```

### Lookup (JOIN)

```javascript
db.orders.aggregate([
  { $match: { status: "pending" } },
  {
    $lookup: {
      from: "users",
      localField: "user_id",
      foreignField: "_id",
      as: "user"
    }
  },
  { $unwind: "$user" },
  { $project: { total: 1, "user.email": 1, "user.name": 1 } }
]);
```

### Change Streams (Real-time)

```javascript
const changeStream = db.orders.watch([
  { $match: { 'updateDescription.updatedFields.status': 'completed' } }
]);

changeStream.on('change', async (change) => {
  const orderId = change.documentKey._id;
  await notificationService.sendOrderConfirmation(orderId);
});

// Persist resume token for fault tolerance
changeStream.on('change', async (change) => {
  await saveResumeToken(change._id);
});
// Resume: db.orders.watch(pipeline, { resumeAfter: savedToken });
```

## Schema Versioning

```javascript
{
  _id: ObjectId("..."),
  schemaVersion: 2,
  name: "John",
  preferences: { theme: "dark" }  // Added in v2
}

// Migrate on read
function migrateDocument(doc) {
  if (!doc.schemaVersion || doc.schemaVersion < 2) {
    doc.preferences = { theme: 'light' };
    doc.schemaVersion = 2;
    // Optionally persist: db.users.updateOne({ _id: doc._id }, { $set: doc });
  }
  return doc;
}
```

## Common Pitfalls

| Pitfall | Fix |
|---------|-----|
| Unbounded arrays (grows forever) | Use bucket pattern or reference |
| Too many collections (1 per user) | Use compound indexes instead |
| No schema versioning | Add schemaVersion field from day 1 |
| $where operator in queries | Use aggregation pipeline instead |
| Missing compound index prefix | Index must start with equality fields |
