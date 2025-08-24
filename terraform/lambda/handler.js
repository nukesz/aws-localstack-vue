exports.handler = async () => {
  const news = [
    { id: 1, title: "News 1", description: "This is news item 1" },
    { id: 2, title: "News 2", description: "This is news item 2" },
    { id: 3, title: "News 3", description: "This is news item 3" },
    { id: 4, title: "News 4", description: "This is news item 4" },
    { id: 5, title: "News 5", description: "This is news item 5" },
    { id: 6, title: "News 6", description: "This is news item 6" },
    { id: 7, title: "News 7", description: "This is news item 7" },
    { id: 8, title: "News 8", description: "This is news item 8" },
    { id: 9, title: "News 9", description: "This is news item 9" },
    { id: 10, title: "News 10", description: "This is news item 10" },
  ];

  return {
    statusCode: 200,
    body: JSON.stringify(news),
    headers: { "Content-Type": "application/json" }
  };
};
