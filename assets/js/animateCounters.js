function respondToVisibility(element, callback) {
    var options = {
    };

    var observer = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            const aaa = entry.isIntersecting;
            callback(entry.intersectionRatio > 0);
        });
    }, options);

    observer.observe(element);
}

const counters = document.querySelectorAll('.counter');

for (let n of counters) {
    const updateCount = () => {
        const target = +n.getAttribute('data-target');
        const sleep = +n.getAttribute('data-sleep');
        const count = +n.innerText;
        const speed = 200;
        const inc = target / speed;
        if (count < target) {
            n.innerText = Math.ceil(count + inc);
            setTimeout(updateCount, sleep);
        } else {
            n.innerText = target;
        }
    }
    respondToVisibility(n, visible => {
        if (visible) {
            updateCount()
        }
    });
}