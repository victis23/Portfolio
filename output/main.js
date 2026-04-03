const topbar = document.getElementById('topbar');
const nav = document.getElementById('nav');
const navToggle = document.getElementById('navToggle');
const revealNodes = document.querySelectorAll('.reveal');
const form = document.getElementById('contactForm');
const formStatus = document.getElementById('formStatus');
const submitButton = document.getElementById('SubmitButton');

function setScrolledState() {
  if (window.scrollY > 12) {
    topbar.classList.add('is-scrolled');
  } else {
    topbar.classList.remove('is-scrolled');
  }
}

setScrolledState();
window.addEventListener('scroll', setScrolledState, { passive: true });

navToggle?.addEventListener('click', () => {
  nav.classList.toggle('is-open');
  document.body.classList.toggle('nav-open');
});

document.querySelectorAll('.nav a').forEach((link) => {
  link.addEventListener('click', () => {
    nav.classList.remove('is-open');
    document.body.classList.remove('nav-open');
  });
});

const observer = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add('is-visible');
        observer.unobserve(entry.target);
      }
    });
  },
  { threshold: 0.16 }
);

revealNodes.forEach((node) => observer.observe(node));

function buildPayload() {
  return {
    name: document.getElementById('NameField').value.trim(),
    email: document.getElementById('EmailField').value.trim(),
    phone: document.getElementById('PhoneNumberField').value.trim(),
    message: document.getElementById('DescriptionField').value.trim(),
    timestamp: Date.now()
  };
}

function clearFields() {
  form.reset();
}

async function persistMessage(payload) {
  if (window.firebase && typeof firebase.firestore === 'function') {
    const db = firebase.firestore();
    await db.collection('Messages').doc().set(payload);
    return 'saved';
  }

  return 'local-only';
}

form?.addEventListener('submit', async (event) => {
  event.preventDefault();

  const payload = buildPayload();
  if (!payload.name || !payload.email || !payload.message) {
    formStatus.textContent = 'Please complete the required fields.';
    return;
  }

  submitButton.disabled = true;
  formStatus.textContent = 'Sending…';

  try {
    const result = await persistMessage(payload);
    clearFields();
    formStatus.textContent =
      result === 'saved'
        ? 'Thanks — your message was submitted successfully.'
        : 'The form UI works, but Firebase was not detected on this page. Add your existing Firebase scripts/config to keep submissions live.';
  } catch (error) {
    console.error(error);
    formStatus.textContent = 'Something went wrong while submitting. Please try again.';
  } finally {
    submitButton.disabled = false;
  }
});
