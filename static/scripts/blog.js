// render the post list on /blog from the generated posts.json
const blogList = document.getElementById('blog-list');

fetch('/blog/posts/posts.json')
    .then(response => {
        if (!response.ok) {
            throw new Error("HTTP error " + response.status);
        }
        return response.json();
    })
    .then(renderPosts)
    .catch(error => {
        console.error("something went wrong:", error);
    });

function renderPosts(posts) {
    blogList.innerHTML = '';

    posts.forEach(post => {
        const postDiv = document.createElement('div');
        const postLink = document.createElement('a');
        const postTitle = document.createElement('h3');
        const postDate = document.createElement('p');
        const postSummary = document.createElement('p');

        postDiv.className = "post-preview";
        postLink.href = post.url;

        postTitle.textContent = post.title;
        postDate.textContent = post.date;
        postSummary.textContent = post.summary;

        postLink.append(postTitle);
        postDiv.append(postLink, postDate, postSummary);

        blogList.appendChild(postDiv);
    });
}
