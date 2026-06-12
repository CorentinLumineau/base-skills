# NoSQL Database Patterns

<!-- ported from mercure-plugin/skills/data-data-persistence/ -->

Detailed modeling patterns for MongoDB and DynamoDB.

## MongoDB Document Modeling

| Factor | Embed | Reference |
|--------|-------|-----------|
| Size | <16MB doc limit | No limit |
| Access | Always together | Independent access |
| Updates | Infrequent | Frequent updates |
| Cardinality | 1:1, 1:few | 1:many, many:many |

```javascript
// Embedded (1:1, 1:few)
{
  _id: ObjectId("..."),
  name: "John",
  address: { street: "123 Main St", city: "Boston" }
}

// Referenced (1:many, many:many)
{ _id: ObjectId("user1"), name: "John" }
{ _id: ObjectId("order1"), user_id: ObjectId("user1"), total: 99.99 }
```

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
```

### Bucket Pattern

For time-series data — group events into time buckets:

```javascript
{
  sensor_id: "s1",
  bucket: "2026-01-28T10",
  count: 60,
  sum: 2520,
  measurements: [
    { t: ISODate("2026-01-28T10:00:00Z"), v: 42 },
    { t: ISODate("2026-01-28T10:01:00Z"), v: 43 }
  ]
}
```

### Outlier Pattern

Embed for the common case, overflow to a separate collection for outliers:

```javascript
// Normal: embedded comments (< 50)
{ _id: "book1", title: "Normal Book", comments: [/* up to ~50 */] }

// Outlier: flag + overflow collection
{ _id: "book2", title: "Viral Book", has_extras: true, comments: [/* first 50 */] }
// Overflow collection: { book_id: "book2", comments: [/* 51+ */] }
```

### Subset Pattern

Store frequently accessed subset in main doc, full data in separate collection:

```javascript
{
  _id: "prod1",
  name: "Widget",
  review_summary: { average: 4.5, count: 1234, recent: [/* top 2-3 */] }
}
// Full reviews in separate collection, loaded on demand
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
      ]
    }
  }
]);
```

### Change Streams

```javascript
const changeStream = db.orders.watch([
  { $match: { 'updateDescription.updatedFields.status': 'completed' } }
]);

changeStream.on('change', async (change) => {
  const orderId = change.documentKey._id;
  await notificationService.sendOrderConfirmation(orderId);
});
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
  if (doc.schemaVersion < 2) {
    doc.preferences = { theme: 'light' };  // Default
    doc.schemaVersion = 2;
  }
  return doc;
}
```

## DynamoDB Single Table Design

Define all access patterns before table design:

| Access Pattern | PK | SK |
|----------------|----|----|
| Get user | USER#123 | PROFILE |
| Get user orders | USER#123 | ORDER#* (begins_with) |
| Get order | ORDER#456 | DETAILS |
| Orders by date | ORDER#DATE#2024 | ORDER#* |

```javascript
// Table structure
{
  PK: "USER#123",
  SK: "PROFILE",
  name: "John",
  email: "john@example.com"
}
{
  PK: "USER#123",
  SK: "ORDER#2024-01-15#456",
  orderId: "456",
  total: 99.99,
  status: "completed"
}

// Query: Get user profile
await docClient.get({ TableName: 'MyTable', Key: { PK: 'USER#123', SK: 'PROFILE' } });

// Query: Get all user orders
await docClient.query({
  TableName: 'MyTable',
  KeyConditionExpression: 'PK = :pk AND begins_with(SK, :prefix)',
  ExpressionAttributeValues: { ':pk': 'USER#123', ':prefix': 'ORDER#' }
});
```

## NoSQL Anti-Patterns

| Anti-Pattern | Fix |
|-------------|-----|
| Modeling relational data in document DB | Design for access patterns |
| Unbounded arrays | Use bucket pattern or reference |
| No schema versioning | Add schemaVersion field from day 1 |
| Cross-partition queries in DynamoDB | Redesign with GSI or access-pattern modeling |
